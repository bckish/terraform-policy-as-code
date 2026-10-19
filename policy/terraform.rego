package main

required_tags := {"owner", "environment"}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.change.after.tags
  missing := required_tags - {key | resource.change.after.tags[key]}
  count(missing) > 0
  msg := sprintf("%s is missing tags: %v", [resource.address, missing])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_subnet"
  resource.change.after.map_public_ip_on_launch == true
  msg := sprintf("%s must not assign public IPs", [resource.address])
}
