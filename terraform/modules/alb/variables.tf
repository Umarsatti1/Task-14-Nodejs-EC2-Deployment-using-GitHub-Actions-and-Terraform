# Input Variables
variable "lb_name" {
  type = string
}

variable "lb_type" {
  type = string
}

variable "tg_name" {
  type = string
}

variable "tg_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}

variable "protocol_version" {
  type = string
}

variable "tg_type" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

variable "listener_type" {
  type = string
}

# Reference
variable "vpc_id" {
  type = string
}

variable "alb_sg" {
  type = string
}

variable "alb_subnet" {
  type = list(string)
}

