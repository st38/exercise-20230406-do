# EC2 Launch template
resource "aws_launch_template" "this" {
  # Launch template name and version description
  name = local.name

  # Application and OS Images (Amazon Machine Image)
  image_id = data.aws_ami.os.id

  # Instance type
  instance_type = var.instance_type

  # Key pair (login)
  key_name = var.key_name

  # Network settings
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = var.security_groups
  }

  # Resource tags
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "${local.name}",
      consul_id = var.consul_id
    }
  }
  dynamic "tag_specifications" {
    for_each = ["volume", "network-interface"]
    content {
      resource_type = tag_specifications.value

      tags = {
        Name = "${local.name}"
      }
    }
  }

  # Advanced details
  iam_instance_profile {
    name = aws_iam_role.this.name
  }

  maintenance_options {
    auto_recovery = "default"
  }

  instance_initiated_shutdown_behavior = "terminate"

  disable_api_termination = false
  disable_api_stop        = false

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = data.cloudinit_config.this.rendered

  # Other
  update_default_version = true
}
