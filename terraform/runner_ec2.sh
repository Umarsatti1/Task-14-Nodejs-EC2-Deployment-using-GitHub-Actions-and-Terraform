#!/bin/bash
set -e

# 1. Wait for network
until ping -c 1 github.com &>/dev/null; do sleep 5; done

# 2. Install Basic Dependencies
apt update -y
apt install -y curl unzip jq git

# 3. Install Node.js 20 & npm (REQUIRED for the runner to execute 'npm install')
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# 4. Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install --update

# 5. Fetch runner token
RUNNER_TOKEN=$(aws ssm get-parameter --name "/github/runner/token" --with-decryption --query "Parameter.Value" --output text --region us-west-1)

# 6. CloudWatch Agent Installation
curl -sS https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -o /tmp/amazon-cloudwatch-agent.deb
dpkg -i -E /tmp/amazon-cloudwatch-agent.deb

# 7. Setup Runner
mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download runner package
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.330.0/actions-runner-linux-x64-2.330.0.tar.gz
tar xzf actions-runner.tar.gz
chown -R ubuntu:ubuntu /home/ubuntu/actions-runner

# Configure as ubuntu user
sudo -u ubuntu ./config.sh \
  --url https://github.com/Umarsatti1/Task-14-Nodejs-EC2-Deployment-using-GitHub-Actions-and-Terraform \
  --token "$RUNNER_TOKEN" \
  --name aws-runner \
  --labels aws,self-hosted \
  --unattended

# Install and start the service
sudo ./svc.sh install ubuntu
sudo ./svc.sh start

# 8. Write CloudWatch Agent configuration
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
cat <<'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
${cw_json}
EOF

# 9. Start CW Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

echo "Runner deployment completed successfully."