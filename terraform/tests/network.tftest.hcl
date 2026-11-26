mock_provider "aws" {}
run "private_network" {
  command = plan
  assert {
    condition     = !aws_subnet.private.map_public_ip_on_launch && aws_vpc.platform.tags.owner == "platform-team"
    error_message = "Expected a private subnet and ownership tags."
  }
}
