resource "aws_internet_gateway" "my_igw" {
  name        = "project-gw"
  vpc_id = aws_vpc.my_vpc.id
}
