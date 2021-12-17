output "data_lake_name" {
  value = oci_objectstorage_bucket.data_lake.name
}

output "database_name" {
  value = var.ADW_database_db_name
}

output "database_display_name" {
  value = var.ADW_database_display_name
}

output "database_connection_urls" {
  value = module.oci-adb.adb_database.connection_urls
}

output "data_catalog_name" {
  value = oci_datacatalog_catalog.lakehouse_catalog.display_name
}

