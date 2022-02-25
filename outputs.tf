## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "data_catalog_name" {
  value = oci_datacatalog_catalog.lakehouse_catalog.display_name
}

output "data_lake_name" {
  value = oci_objectstorage_bucket.data_lake.name
}

output "ADW_name" {
  value = var.create_ADW ? var.ADW_database_db_name : null
}

output "ADW_display_name" {
  value = var.create_ADW ? var.ADW_database_display_name : null
}

output "ADW_connection_urls" {
  value = var.create_ADW ? module.oci-adb[0].adb_database.connection_urls : null
}

output "MDS_IP" {
  value     = var.create_MDS ? module.mds-instance[0].mysql_db_system.ip_address : null
  sensitive = true
}

