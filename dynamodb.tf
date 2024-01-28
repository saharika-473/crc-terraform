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

  attribute {
    name = "visitor_count"
    type = "S"
  }

  tags = var.tags
}
