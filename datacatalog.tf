resource "oci_datacatalog_catalog" "lakehouse_catalog" {
  compartment_id = var.compartment_ocid
  display_name = var.data_catalog_display_name
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_adw" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "${var.ADW_database_display_name}_data_asset"
  description  = "Autonomous Data Warehouse instance and region"
  properties = {
    "default.database"        = var.ADW_database_db_name
    "default.privateendpoint" = ""
  }
  type_key = data.oci_datacatalog_catalog_types.adw_data_asset.type_collection[0].items[0].key
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_data_lake" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "${var.data_lake_bucket_name}_data_asset"
    properties = {
      "default.namespace" = data.oci_objectstorage_namespace.bucket_namespace.namespace
      "default.url"       = "https://swiftobjectstorage.${var.region}.oraclecloud.com"
    }
  type_key = data.oci_datacatalog_catalog_types.objectstorage_data_asset.type_collection[0].items[0].key
}

resource oci_datacatalog_connection adw_connection {
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_adw.key
  display_name = "${var.ADW_database_display_name}_data_connection"
  is_default = "true"
  properties = {
    "default.alias"            = "${var.ADW_database_db_name}_low"
    "default.username"         = "ADMIN"
    "default.walletAndSecrets" = "plainWallet"
  }
  enc_properties = {
    "default.password"         = var.ADW_database_password
    "default.wallet"           = module.oci-adb.adb_database.adb_wallet_content
  }
  type_key = data.oci_datacatalog_catalog_types.adw_generic_connection.type_collection[0].items[0].key
}

resource oci_datacatalog_connection data_lake_connection {
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_data_lake.key
  display_name = "${var.data_lake_bucket_name}_data_connection"
  is_default = "true"
  properties = {
    "default.ociCompartment" = var.compartment_ocid
    "default.ociRegion"      = var.region
  }
  type_key = data.oci_datacatalog_catalog_types.resource_principal_connection.type_collection[0].items[0].key
}
