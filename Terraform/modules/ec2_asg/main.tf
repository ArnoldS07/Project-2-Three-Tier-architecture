data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/canonical/ubuntu/server/jammy/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_launch_template" "this" {
  name_prefix             = "${var.name}-lt-"
  image_id                = data.aws_ssm_parameter.al2023_ami.value
  instance_type           = var.instance_type
  vpc_security_group_ids  = [var.app_sg_id]

  # Add your key pair here
  key_name = var.key_name   # pass the key name via variable

  iam_instance_profile {
    name = var.iam_instance_profile
  }
}
  user_data = base64encode(
    templatefile("${path.module}/user_data.sh.tftpl", {
      region            = var.region
      ecr_repo_frontend = var.ecr_repo_frontend
      ecr_repo_backend  = var.ecr_repo_backend
      db_host           = var.db_host
      db_user           = var.db_user
      db_pass           = var.db_pass
      db_port           = var.db_port
    })
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-app"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.name}-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.desired_capacity
  min_size            = var.desired_capacity
  vpc_zone_identifier = var.private_app_subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_tg_arn]
  health_check_type = "EC2"
}
