resource "oci_datacatalog_catalog" "lakehouse_catalog" {
  compartment_id = var.compartment_ocid
  display_name = var.data_catalog_display_name
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_adw" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "Lakehousedb"
  description  = "Autonomous Data Warehouse instance from compartment - lakehouse1 and region - US East (Ashburn)"
  properties = {
    "default.database"        = "Lakehousedb"
    "default.privateendpoint" = ""
  }
  type_key = "38320846-a7c3-465f-b88d-4fb1a0ee8389"
  #type = ADW
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_bucket" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "genre_json"
    properties = {
      "default.namespace" = "c4u04"
      "default.url"       = "https://swiftobjectstorage.us-ashburn-1.oraclecloud.com"
    }
  type_key = "3ea65bc5-f60d-477a-a591-f063665339f9"
  #type = Object Storage
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_data_lake" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "data-lake"
    properties = {
      "default.namespace" = data.oci_objectstorage_namespace.bucket_namespace.namespace
      "default.url"       = "https://swiftobjectstorage.${var.region}.oraclecloud.com"
    }
  type_key = "3ea65bc5-f60d-477a-a591-f063665339f9"
  #type = Object Storage
}

resource oci_datacatalog_connection Lakehousedb {
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_adw.key
  display_name = "Lakehousedb"
  is_default = "true"
  properties = {
    "default.alias"            = "lakehousedb_low"
    "default.username"         = "ADMIN"
    "default.walletAndSecrets" = "plainWallet"
  }
  enc_properties = {
    "default.password"         = var.ADW_password
    "default.wallet"           = module.oci-adb.adb_database.adb_wallet_content
  }
  type_key = "5a33e7be-c49b-4062-a842-d4972a626547"
  #type = Generic
}

resource oci_datacatalog_connection json_connection {
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_bucket.key
  display_name = "json_connection"
  is_default = "true"
  properties = {
    "default.parUrl" = "https://objectstorage.us-ashburn-1.oraclecloud.com/p/ouDV0uXS0m0vSkJ7Ok2-W0FfSPIsLDHkXF7aSBevClUpS7zdD0wOe4DHVn5r5IvY/n/c4u04/b/data_lakehouse/o/"
  }
  type_key = "e9dd2300-318c-4266-ad37-3ee1fad16fc5"
  #type = Pre-authenticated request
}

resource oci_datacatalog_connection data_lake_connection {
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_data_lake.key
  display_name = "data_lake_connection"
  is_default = "true"
  properties = {
    "default.parUrl" = "https://objectstorage.${var.region}.oraclecloud.com${oci_objectstorage_preauthrequest.data_lake_par.access_uri}"
  }
  type_key = "e9dd2300-318c-4266-ad37-3ee1fad16fc5"
  #type = Pre-authenticated request
}
