output "instance_public_ip" {
  description = "Public IP adress"
  value = aws_instance.app_server.public_ip
}

output "api_url" {
  description = "The URL"
  value = "http://${aws_instance.app_server.public_ip}"
}