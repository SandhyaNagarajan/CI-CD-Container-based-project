/*

Main configuration file for Terraform

Terraform configuration files are written in the HashiCorp Congiuration Language (HCL).
For more information on HCL syntax, visit:

https://www.terraform.io/docs/configuration/syntax.html

 */
 /*
 02.08.18 : added aws as provider
 */

provider "aws" {
    region   = "${var.aws_region}"
    version  = "~> 1.14"
}



/*
 02.08.18 : added jenkins server

Configuration for a simple EC2 instance for jenkins server,
within our VPC and with our open sg assigned to them

For all the arguments and options, visit:
https://www.terraform.io/docs/providers/aws/r/instance.html

 */

# Configuration for a "jenkins" instance

resource "aws_instance" "jenkins" {
  ami = "ami-ba602bc2"
  instance_type = "m4.large"
  key_name        = "${var.keypair_name}"
  tags {
  Name = "jenkins-server"
  }
 # 02.08.18 :  you need to tell the EC2 Instance to actually use the new security group.

  vpc_security_group_ids = ["${aws_security_group.sg_jenkins.id}"]
}

/*
08.06.2018: added stagging servers
*/
resource "aws_instance" "stagging" {
  ami = "ami-ba602bc2"
  instance_type = "m4.large"
  key_name        = "${var.keypair_name}"
  tags {
  Name = "stagging-server"
  }
 # 06.08.18 :  Using the same security group for stagging server as Jenkins

  vpc_security_group_ids = ["${aws_security_group.sg_jenkins.id}"]
}


/*
08.02.2018:output the public ip of the instance
*/
output "jenkins_ip" {
  value = "${aws_instance.jenkins.public_dns}"
}

output "stagging_ip" {
  value = "${aws_instance.stagging.public_dns}"
}

/*
08.03.2018: security group for jenkins
*/

resource "aws_security_group" "sg_jenkins" {
  name = "sg_jenkins"
  description = "Allows all traffic"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Jenkins JNLP port
  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Weave Scope port
  ingress {
    from_port = 4040
    to_port = 4040
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
