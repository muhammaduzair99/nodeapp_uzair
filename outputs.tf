output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app_alb.arn
}

output "target_group_arn" {
  description = "ARN of the Node.js app Target Group"
  value       = aws_lb_target_group.app_tg.arn
}

output "mysql_endpoint" {
  description = "Endpoint for MySQL RDS instance"
  value       = aws_db_instance.mysql.endpoint
}
