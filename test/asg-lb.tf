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
}


resource "aws_lb" "capstone-lb" {
  name = "${var.tags}-load-balancer"
  load_balancer_type = "application"
  security_groups = [ aws_security_group.load-balancer-sec.id ]
  subnet_mapping {
  subnet_id = aws_subnet.public-1a.id  
  } 
  subnet_mapping {
    subnet_id = aws_subnet.public-1b.id
  }
  
}

resource "aws_lb_listener" "capstone-listener" {
  load_balancer_arn = aws_lb.capstone-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.capstone-target.arn
  }
}

# resource "aws_lb_listener" "http-https" {
#   load_balancer_arn = aws_lb.capstone-lb.arn
#   port = 443
#   protocol = "HTTPS"
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.capstone-target.arn
#   }
  
# }

resource "aws_autoscaling_group" "capstone-asg" {
  name                      = "${var.tags}-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 200
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
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
    value               = "nht-1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "capstone-attachment" {
  autoscaling_group_name = aws_autoscaling_group.capstone-asg.id
  lb_target_group_arn = aws_lb_target_group.capstone-target.arn
  
}