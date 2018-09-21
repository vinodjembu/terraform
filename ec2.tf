# Uncomment resources below and add required arguments.

resource "aws_security_group" "dse_sec_grp" {
  name = "dse_sec_grp"
  description = "dse security group- allow all"
  vpc_id = "vpc-001394d0ecbcdfae1"
}

resource "aws_security_group_rule" "ssh_ingress_access" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ] 
  security_group_id = "${aws_security_group.dse_sec_grp.id}"
}

resource "aws_security_group_rule" "egress_access" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.dse_sec_grp.id}"
}

resource "aws_instance" "jembu-node" {
  instance_type = "t2.xlarge"
  vpc_security_group_ids = [ "${aws_security_group.dse_sec_grp.id}" ]
  associate_public_ip_address = true
 # user_data = "${file("../../shared/user-data.txt")}"
  tags {
    Name = "jembu-node"
  }
  
  ami = "ami-0c54494f920b19106"
  availability_zone = "us-east-1b"
  subnet_id = "subnet-0e79be898021453fb"
}
