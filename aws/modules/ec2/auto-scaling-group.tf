# Auto Scaling group
resource "aws_autoscaling_group" "this" {
  name             = local.name
  desired_capacity = var.desired_capacity
  max_size         = var.desired_capacity
  min_size         = var.desired_capacity

  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Default"
  }
}
