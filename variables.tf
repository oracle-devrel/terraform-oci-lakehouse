## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint"{}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

################### ADW Variables ####################

variable "create_ADW" {
  default = true
}

variable "ADW_database_db_name" {
  default = "lakehouseADW"
}

variable "ADW_database_db_version" {
  default = "19c"
}

variable "ADW_database_display_name" {
  default = "lakehouseADW"
}

variable "ADW_database_password" {
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

################## MySQL Variables ###################

variable "create_MDS" {
  default = false
}

variable "mysql_db_system_admin_username" {
  description = "MySQL Database Service Username"
  default = "admin"
}

variable "mysql_db_system_admin_password" {
  description = "Password for the admin user for MySQL Database Service"
  default = "Password2022#"
}

variable "mysql_shape" {
  default = "MySQL.VM.Standard.E3.1.8GB"
}

variable "mysql_heatwave_shape" {
  description = "The shape to be used instead of mysql_shape_name when mysql_heatwave_enabled = true."
  default     = "MySQL.HeatWave.VM.Standard.E3"
}

variable "mysql_heatwave_enabled" {
  description = "Defines whether a MySQL HeatWave cluster is enabled"
  default     = true
}

variable "mysql_heatwave_cluster_size" {
  description = "Number of MySQL HeatWave nodes to be created"
  default     = 2
}

variable "deploy_mds_ha" {
  description = "Deploy High Availability for MDS"
  type        = bool
  default     = false
}

variable "mysql_db_system_data_storage_size_in_gb" {
  default = 50
}

variable "mysql_db_system_description" {
  description = "Lakehouse MySQL DB System"
  default = "Lakehouse MySQL DB System"
}

variable "mysql_db_system_display_name" {
  description = "MySQL DB System display name"
  default = "lakehouseMDS"
}

variable "mysql_db_system_fault_domain" {
  description = "The fault domain on which to deploy the Read/Write endpoint. This defines the preferred primary instance."
  default = "FAULT-DOMAIN-1"
}                  

variable "mysql_db_system_hostname_label" {
  description = "The hostname for the primary endpoint of the DB System. Used for DNS. The value is the hostname portion of the primary private IP's fully qualified domain name (FQDN) (for example, dbsystem-1 in FQDN dbsystem-1.subnet123.vcn1.oraclevcn.com). Must be unique across all VNICs in the subnet and comply with RFC 952 and RFC 1123."
  default = "lakehouseMDS"
}

variable "mysql_db_system_maintenance_window_start_time" {
  description = "The start of the 2 hour maintenance window. This string is of the format: {day-of-week} {time-of-day}. {day-of-week} is a case-insensitive string like mon, tue, etc. {time-of-day} is the Time portion of an RFC3339-formatted timestamp. Any second or sub-second time data will be truncated to zero."
  default = "SUNDAY 14:30"
}

################# Network Variables ##################

variable "existing_vcn_ocid" {
  description = "OCID of an existing VCN to use"
  default     = ""
}

variable "existing_public_subnet_ocid" {
  description = "OCID of an existing public subnet to use"
  default     = ""
}

variable "existing_private_subnet_ocid" {
  description = "OCID of an existing private subnet to use"
  default     = ""
}

variable "existing_internet_gateway_ocid" {
  description = "OCID of an existing internet gateway to use"
  default     = ""
}

variable "existing_nat_gateway_ocid" {
  description = "OCID of an existing NAT gateway to use"
  default     = ""
}

variable "existing_public_route_table_ocid" {
  description = "OCID of an existing public route table to use"
  default     = ""
}

variable "existing_private_route_table_ocid" {
  description = "OCID of an existing private route table to use"
  default     = ""
}

variable "existing_public_security_list_ocid" {
  description = "OCID of an existing public security list (ssh) to use"
  default     = ""
}

variable "existing_public_security_list_http_ocid" {
  description = "OCID of an existing security list allowing http and https to use"
  default     = ""
}

variable "existing_private_security_list_ocid" {
  description = "OCID of an existing private security list allowing MySQL access to use"
  default     = ""
}

variable "existing_mds_instance_ocid" {
  description = "OCID of an existing MDS instance to use"
  default     = ""
}

variable "vcn" {
  description = "VCN Name"
  default     = "mysql_vcn"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

######################################################

variable "data_catalog_display_name" {
  default = "lakehousecatalog"
}

variable "data_lake_bucket_name" {
  default = "data-lake"
}

variable "release" {
  default = "1.1"
}