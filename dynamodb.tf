resource "aws_dynamodb_table" "terraform_lock_table" {
  name           = "terraform-lock-table"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  read_capacity  = 20
  write_capacity = 20
}
