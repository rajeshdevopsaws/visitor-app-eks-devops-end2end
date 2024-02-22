resource "random_string" "suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric  = false
  special = false
}
