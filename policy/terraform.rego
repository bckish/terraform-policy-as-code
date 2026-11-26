package main

required_tags := {"owner", "environment"}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.mode == "managed"
  resource.change.after != null
  tags := object.get(resource.change.after, "tags", {})
  missing := required_tags - {key | value := tags[key]; is_string(value); trim_space(value) != ""}
  count(missing) > 0
  msg := sprintf("%s is missing tags: %v", [resource.address, missing])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.mode == "managed"
  resource.change.after != null
  resource.type == "aws_subnet"
  resource.change.after.map_public_ip_on_launch == true
  msg := sprintf("%s must not assign public IPs", [resource.address])
}
