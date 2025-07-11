output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "s3_bucket" {
  value = aws_s3_bucket.mybucket.bucket
}
