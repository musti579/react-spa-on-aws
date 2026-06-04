variable "ecs_task_execution_role_arn" {
  type = string
}

variable "vpc_id" {
type = string
}
variable "public_subnet_ids" {
type = list(string)
}
variable "alb_security_group_id" {
type = string
}
variable "target_group_arn" {
type = string
}