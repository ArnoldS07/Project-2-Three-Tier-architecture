data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/canonical/ubuntu/server/jammy/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_launch_template" "this" {
  name_prefix             = "${var.name}-lt-"
  image_id                = data.aws_ssm_parameter.al2023_ami.value
  instance_type           = var.instance_type
  vpc_security_group_ids  = [var.app_sg_id]
  key_name                = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  # User data must be base64 encoded if using aws_launch_template
  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    region            = var.region
    ecr_repo_frontend = var.ecr_repo_frontend
    ecr_repo_backend  = var.ecr_repo_backend
    db_host           = var.db_host
    db_user           = var.db_user
    db_pass           = var.db_pass
    db_port           = var.db_port
  }))

  # Tags go inside launch template like this:
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-instance"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity     = var.desired_capacity
  max_size             = var.desired_capacity
  min_size             = var.desired_capacity
  vpc_zone_identifier  = var.private_app_subnets
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}
