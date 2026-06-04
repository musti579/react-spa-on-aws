resource "aws_ecs_cluster" "cluster" {
  name = "threatmod-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}