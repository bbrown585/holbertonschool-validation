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

resource "aws_instance" "awesome-production-instance" {
	ami = "ami-0568936c8d2b91c4e"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.awesome-sg.id]
	key_name = aws_key_pair.awesome-key.key_name
	tags = {
		Name = "production"
	}
}

resource "aws_instance" "awesome-jenkins-instance" {
	ami = "ami-0568936c8d2b91c4e"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.awesome-sg.id]
	key_name = aws_key_pair.awesome-key.key_name
	tags = {
		Name = "jenkins"
	}
}
