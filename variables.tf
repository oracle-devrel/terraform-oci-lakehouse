variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint"{}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "ADW_database_db_name" {
  default = "lakehousedb"
}


variable "catalog_display_name" {
  default = "lakehousecatalog"
}
