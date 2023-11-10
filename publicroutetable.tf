# Create a public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  
  tags = {
    Name = "project"
  }
}

# Create a route in the public route table for internet access
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}
# Associate the public route table with your public subnets

resource "aws_route_table_association" "public_subnet_association1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}