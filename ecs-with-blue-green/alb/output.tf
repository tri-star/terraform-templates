output "alb_listener_prod_arn" {
  value = aws_lb_listener.prod.arn
}

output "alb_listener_standby_arn" {
  value = aws_lb_listener.standby.arn
}

output "alb_target_group1_arn" {
  value = aws_lb_target_group.tg1.arn
}
output "alb_target_group1_name" {
  value = aws_lb_target_group.tg1.name
}

output "alb_target_group2_name" {
  value = aws_lb_target_group.tg2.name
}
