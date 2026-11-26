package main

test_valid_private_subnet if {
  violations := deny with input as {"resource_changes":[{"mode":"managed","type":"aws_subnet","address":"aws_subnet.example","change":{"after":{"map_public_ip_on_launch":false,"tags":{"owner":"platform","environment":"qa"}}}}]}
  count(violations) == 0
}

test_public_and_missing_tags if {
  violations := deny with input as {"resource_changes":[{"mode":"managed","type":"aws_subnet","address":"aws_subnet.example","change":{"after":{"map_public_ip_on_launch":true,"tags":{"owner":" "}}}}]}
  count(violations) == 2
}

test_missing_tag_object if {
  violations := deny with input as {"resource_changes":[{"mode":"managed","type":"aws_vpc","address":"aws_vpc.example","change":{"after":{}}}]}
  count(violations) == 1
}

test_deletion_and_data_ignored if {
  violations := deny with input as {"resource_changes":[{"mode":"managed","type":"aws_vpc","address":"aws_vpc.example","change":{"after":null}},{"mode":"data","type":"aws_vpc","address":"data.aws_vpc.example","change":{"after":{}}}]}
  count(violations) == 0
}
