resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  
  tags = {
    Name = "project"
  }
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}
}