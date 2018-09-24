
#AWS Provider access deatils (AWS)

provider "aws" {
    access_key = "Enter AWS ACCESS KEY"
    secret_key = "Enter AWS SECRET KEY"
    region = "us-east-1"
}


#Un-Comment if you want to launch instance with new security group or applying new rules

/*
resource "aws_security_group" "dse" {
  name = "dse"
  description = "dse security group- allow all"

  #your virtual private cloud
  vpc_id = "vpc-001394d0ecbcdfae1"
}

resource "aws_security_group_rule" "ssh_ingress_access" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ] 
  security_group_id = "${aws_security_group.dse.id}"
}

resource "aws_security_group_rule" "egress_access" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.dse.id}"
}
*/

resource "aws_instance" "dse-node" {
  # number of instances
  count = 3

  #Define Instance type - for free-tier refer AWS documentation
  instance_type = "t2.xlarge"  
  
  #Un-Comment (line 3 ,27 and below) if you want to use above created security group
  #vpc_security_group_ids = [ "${aws_security_group.dse.id}" ]

  # For Existing security group -Provide your AWS security group
  security_groups=["sg-0e6bb77f8d9723052"]

  #Add Exisitng keypair - SSH Connection with private key pair. if keypair not available, generate one through AWS console. Refer AWS documentation
  key_name="jembukeypair"
  
  associate_public_ip_address = true
  tags {
    #Instance Tag name
    Name = "dse-node - ${count.index}"
  }

  #Define image type - below for Ubuntu 14.4
  ami = "ami-0c54494f920b19106"

  #Define availability zone  - For multiple region, use loop with index variable
  availability_zone = "us-east-1b"

  #Subnet Id associated with your VPC
  subnet_id = "subnet-0e79be898021453fb"
}
