#Creating key-pair for logging into EC2 in us-west-1



#Creating and bootstraping EC2 in us-west-1 region subnet_1 

resource "aws_instance" "bala_instance_1" {
    ami = var.ami
    instance_type = var.instance-type
    associate_public_ip_address = "true"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = aws_subnet.subnet_1.id
    tags = {
        Name = "bala_instance_1"
    }
    depends_on = [aws_main_route_table_association.my-rt-association]
}

#Creating and bootstraping EC2 in us-west-1 region subnet_2 

resource "aws_instance" "bala_instance_2" {
    ami = var.ami
    instance_type = var.instance-type
    associate_public_ip_address = "true"
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = aws_subnet.subnet_2.id
    tags = {
        Name = "bala_instance_2"
    }
    depends_on = [aws_main_route_table_association.my-rt-association]
}
