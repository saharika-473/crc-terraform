resource "aws_dynamodb_table" "terraform_lock_table" {
  name           = "terraform-lock-table"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  read_capacity  = 20
  write_capacity = 20
  tags = var.tags
}

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
  name         = "${local.naming_convention}-unique-visitor-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "ip_address"

  attribute {
    name = "ip_address"
    type = "S"
  }


  tags = var.tags
}
