output "instance-info" {
	value = [for instance in aws_instance.awesome-instance: {
		public_dns = instance.public_dns
		public_ip = instance.public_ip
		tags = instance.tags
	}]
}

data "aws_instances" "production" {
	filter {
		name = "tag:Name"
		values = ["production"]
	}
}

output "production" {
	value = data.aws_instances.production.public_ips[0]
}

data "aws_instances" "jenkins" {
	filter {
		name = "tag:Name"
		values = ["jenkins"]
	}
}

output "jenkins" {
	value = data.aws_instances.jenkins.public_ips[0]
}