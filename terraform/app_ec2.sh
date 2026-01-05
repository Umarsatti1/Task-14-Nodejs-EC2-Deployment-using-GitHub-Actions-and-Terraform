#!/bin/bash
set -e

# 1. Update and install dependencies
apt update -y
apt install -y curl git unzip nginx

# 2. Install Node.js 20 & PM2
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs
npm install -g pm2

# 3. Application Setup
mkdir -p /var/www/app
cd /var/www/app

# Clone and set permissions
git clone https://github.com/Umarsatti1/Task-14-Nodejs-EC2-Deployment-using-GitHub-Actions-and-Terraform.git .
mkdir -p /var/www/app/logs
chown -R ubuntu:ubuntu /var/www/app

# 4. Start App as 'ubuntu' user (Crucial for visibility)
sudo -u ubuntu npm install --omit=dev
sudo -u ubuntu pm2 start app.js --name nodejs-app -l /var/www/app/logs/app.log
sudo -u ubuntu pm2 save

# Setup PM2 startup for the ubuntu user
env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

# 5. Nginx Config (Quotes on 'EOF' are GOOD here to protect Nginx variables)
cat <<'EOF' >/etc/nginx/sites-available/nodejs-app
server {
    listen 80;
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
    location /health {
        return 200 "OK\n";
    }
}
EOF

ln -sf /etc/nginx/sites-available/nodejs-app /etc/nginx/sites-enabled/nodejs-app
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

# 6. CloudWatch Agent
curl -sS https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -o /tmp/amazon-cloudwatch-agent.deb
dpkg -i -E /tmp/amazon-cloudwatch-agent.deb

# 7. Write CloudWatch Agent configuration
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat <<'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
${cw_json}
EOF

# 8. Start Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s