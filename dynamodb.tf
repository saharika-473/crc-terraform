resource "aws_dynamodb_table" "visit_counter" {
  name         = "${local.naming_convention}-visit-counter-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }


  tags = var.tags
}

resource "aws_dynamodb_table" "unique_visitor" {
  name         = "${local.naming_convention}-unique-ipaddress-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "ip_address"

  attribute {
    name = "ip_address"
    type = "S"
  }


  tags = var.tags
}
