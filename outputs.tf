output "par_request_uri" {
  //value = oci_datacatalog_connection.data_lake_connection.properties["default.parUrl"]
  value = "https://objectstorage.${var.region}.oraclecloud.com${oci_objectstorage_preauthrequest.data_lake_par.access_uri}"
}

