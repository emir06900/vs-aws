resource "aws_route_table" "public_rt" {
  name        = "project-prt"
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public_rt_igw" {
  name        = "project-prtadd"
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}