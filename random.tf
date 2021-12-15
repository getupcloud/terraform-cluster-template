resource "random_string" "suffix" {
  length  = 16
  special = false
  upper   = false
}

resource "random_string" "secret" {
  length  = 128
  special = false
  upper   = true
  number  = true
}
