resource "aws_ecs_cluster" "cluster" {
  name = "threatmod-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/threatmod"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "threatmod-container"
      image     = "868256361535.dkr.ecr.eu-north-1.amazonaws.com/ecs-project:latest"
      cpu       = 0
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/ecs-app"
          awslogs-region        = "eu-north-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  
}