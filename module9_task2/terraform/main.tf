provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "awesome-key" {
	key_name = "awesome-key"
	public_key = file("~/.ssh/awesome-key.pub")
}

resource "aws_security_group" "awesome-sg" {
	name = "awesome-sg"
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "awesome-instance" {
	for_each = var.instance_tags
	ami = "ami-0568936c8d2b91c4e"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.awesome-sg.id]
	key_name = aws_key_pair.awesome-key.key_name
	tags = {
		Name = each.key
		Description = each.value
	}
	user_data = data.cloudinit_config.server_config.rendered 
	
	connection {
		type 		= "ssh"
		user		= "ubuntu"
		private_key	= file("~/.ssh/awesome-key.pem")
		host 		= self.public_ip
	}
}


data "cloudinit_config" "server_config" {
	gzip 		= false
	base64_encode = true 
	
	part {
		content_type = "text/cloud-config"
		content = file("./userdata/default.yml")
	}
}