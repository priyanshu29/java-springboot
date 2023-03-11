# Configure the AWS provider

provider "aws" {

  region = "ap-south-1" # Replace with your desired region

}

data "aws_vpc" "defaultvpc" {

  id = "vpc-0d7f88c6f873598f5" # Replace with the ID of your existing VPC

}


 

data "aws_subnet" "rds_subnet" {

  id = "subnet-0fcd804db9355aa05" # Replace with the ID of your existing subnet

}


 

data "aws_security_group" "tom" {

  id = "sg-0253b8d971bda1100" # Replace with the ID of your existing security group

}

# Create a VPC and subnet

# resource "aws_vpc" "ecs_vpc" {

#   cidr_block = "10.0.0.0/16"

# }


 

# resource "aws_subnet" "ecs_subnet" {

#   cidr_block = "10.0.1.0/24"

#   vpc_id     = aws_vpc.ecs_vpc.id

# }


 

# Create an ECS cluster

resource "aws_ecs_cluster" "my_cluster" {

  name = "java-devops"

}


 

# Create an IAM role for ECS tasks

resource "aws_iam_role" "ecs_task_role" {

  name = "ecs-task-role"


 

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}


 

# Create a task definition

resource "aws_ecs_task_definition" "my_task_definition" {

  family = "my-task"

  container_definitions = jsonencode([

    {

      name = "coupon-app"

      image = "priyanshu0998/coupon-app:latest"

      portMappings = [

        {

          containerPort = 8090

          hostPort = 8090

        }

      ]

      # logConfiguration = {

      #   logDriver = "awslogs"

      #   options = {

      #     "awslogs-group" = "/ecs/my-task"

      #     "awslogs-region" = "ap-south-1"

      #     "awslogs-stream-prefix" = "ecs"

      #   }

      # }

    }

  ])

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  memory = "512"

  cpu = "256"

  execution_role_arn = aws_iam_role.ecs_task_role.arn

  task_role_arn = aws_iam_role.ecs_task_role.arn

}


 

# Create a service that runs tasks in the cluster

resource "aws_ecs_service" "my_service" {

  name = "my-service"

  cluster = aws_ecs_cluster.my_cluster.id

  task_definition = aws_ecs_task_definition.my_task_definition.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = [data.aws_subnet.rds_subnet.id]

    security_groups = [data.aws_security_group.tom.id]

    assign_public_ip = true

  }

}


 

# Create a security group for the ECS tasks

# resource "aws_security_group" "ecs_security_group" {

#   name_prefix = "ecs-"

#   vpc_id = defaultvpc.defaultvpc.id


 

#   ingress {

#     from_port = 0

#     to_port = 65535

#     protocol = "tcp"

#     cidr_blocks = ["0.0.0.0/0"]

#   }


 

#   egress {

#     from_port = 0

#     to_port = 65535

#     protocol = "tcp"

#     cidr_blocks = ["0.0.0.0/0"]

#   }

# }


 