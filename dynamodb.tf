resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "viewCount"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }
}
