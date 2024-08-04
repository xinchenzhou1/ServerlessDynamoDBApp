resource "aws_dynamodb_table" "dynamodb-table-museum-demo" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "MuseumName" //Partition Key
  range_key      = "CollectionHighlight" // Sort Key

  attribute {
    name = "CollectionHighlight"
    type = "S"
  }

  attribute {
    name = "MuseumName"
    type = "S"
  }

  attribute {
    name = "MuseumType"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "type-index"
    hash_key           = "MuseumType"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "ALL"
  }

  tags = {
    Name        = "dynamodb-table-museum-demo"
    Environment = "production"
  }
}