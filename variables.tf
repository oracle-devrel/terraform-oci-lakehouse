variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint"{}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

variable "ADW_database_db_name" {
  default = "lakehousedb"
}

variable "ADW_database_db_version" {
  default = "19c"
}

variable "ADW_database_display_name" {
  default = "lakehousedb"
}

variable "ADW_password" {
  default = "Password2022#"
}

variable "ADW_database_cpu_core_count" {
  default = 1
}

variable "ADW_database_data_storage_size_in_tbs" {
  default = 1
}
variable "ADW_database_freeform_tags" {
  default = {
    "Owner" = ""
  }
}

variable "ADW_database_defined_tags_value" {
  default = ""
}

variable "ADW_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "catalog_display_name" {
  default = "lakehousecatalog"
}
