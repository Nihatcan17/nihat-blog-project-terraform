resource "aws_lb_target_group" "capstone-target" {
  name     = "${var.tags}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.capstone-vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
  tags = {
    "Name" = "${var.tags}-asg"
  }
  target_type = "instance"
  depends_on = [
    aws_lb.capstone-lb
  ]
}


resource "aws_lb" "capstone-lb" {
  name               = "${var.tags}-load-balancer"
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups    = [aws_security_group.load-balancer-sec.id]
  subnet_mapping {
    subnet_id = aws_subnet.public-1a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.public-1b.id
  }

}

resource "aws_lb_listener" "https-listener" {
  load_balancer_arn = aws_lb.capstone-lb.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone-target.arn
  }
  certificate_arn = data.aws_acm_certificate.certificate.arn
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.capstone-lb.arn
  protocol = "HTTP"
  port = 80
  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      host = "#{host}"
      path = "/#{path}"
      query = "#{query}"
      status_code = "HTTP_301"
    }  
  }  
}

resource "aws_autoscaling_group" "capstone-asg" {
  name                      = "${var.tags}-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 200
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  wait_for_capacity_timeout = "2m"
  depends_on = [
    aws_instance.nat-instance
  ]
  launch_template {
    id      = aws_launch_template.asg-lt.id
    version = "1"
  }
  vpc_zone_identifier = [aws_subnet.private-1a.id, aws_subnet.private-1b.id]


  tag {
    key                 = "name"
    value               = "${var.tags}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "capstone-attachment" {
  autoscaling_group_name = aws_autoscaling_group.capstone-asg.id
  lb_target_group_arn    = aws_lb_target_group.capstone-target.arn

}


resource "aws_autoscaling_policy" "scale_down" {
  autoscaling_group_name = aws_autoscaling_group.capstone-asg.name
  name                   = "${var.tags}-scale-down"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  policy_type = "SimpleScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }

}



resource "aws_autoscaling_policy" "scale_up" {
  autoscaling_group_name = aws_autoscaling_group.capstone-asg.name
  name                   = "${var.tags}-scale-up"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "+1"
  policy_type = "SimpleScaling"
  target_tracking_configuration {
     predefined_metric_specification {
       predefined_metric_type = "ASGAverageCPUUtilization"
     }
     target_value = 70.0
  }
}
