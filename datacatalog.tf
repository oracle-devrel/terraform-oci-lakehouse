## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_datacatalog_catalog" "lakehouse_catalog" {
  compartment_id                     = var.compartment_ocid
  display_name                       = var.data_catalog_display_name
  defined_tags                       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  attached_catalog_private_endpoints = var.create_MDS ? [oci_datacatalog_catalog_private_endpoint.lakehouse_catalog_mysql_private_endpoint[0].id] : null
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_adw" {
  count        = var.create_ADW ? 1 : 0
  catalog_id   = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "${var.ADW_database_display_name}_data_asset"
  description  = "Autonomous Data Warehouse data asset"
  properties = {
    "default.database"        = var.ADW_database_db_name
    "default.privateendpoint" = ""
  }
  type_key = data.oci_datacatalog_catalog_types.adw_data_asset.type_collection[0].items[0].key
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_mds" {
  count        = var.create_MDS ? 1 : 0
  catalog_id   = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "${var.mysql_db_system_display_name}_data_asset"
  description  = "MySQL data asset"
  properties = {
    "default.host"            = module.mds-instance[0].mysql_db_system.endpoints[0].hostname
    "default.port"            = "3306"
    "default.database"        = "mysql"
    "default.privateendpoint" = "true"
  }
  type_key = data.oci_datacatalog_catalog_types.mysql_data_asset.type_collection[0].items[0].key
}

resource "oci_datacatalog_data_asset" "lakehouse_data_asset_data_lake" {
  catalog_id   = oci_datacatalog_catalog.lakehouse_catalog.id
  display_name = "${var.data_lake_bucket_name}_data_asset"
  properties = {
    "default.namespace" = data.oci_objectstorage_namespace.bucket_namespace.namespace
    "default.url"       = "https://swiftobjectstorage.${var.region}.oraclecloud.com"
  }
  type_key = data.oci_datacatalog_catalog_types.objectstorage_data_asset.type_collection[0].items[0].key
}


resource "oci_datacatalog_connection" "adw_connection" {
  count          = var.create_ADW ? 1 : 0
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_adw[0].key
  display_name   = "${var.ADW_database_display_name}_data_connection"
  is_default     = "true"
  properties = {
    "default.alias"            = "${var.ADW_database_db_name}_low"
    "default.username"         = "ADMIN"
    "default.walletAndSecrets" = "plainWallet"
  }
  enc_properties = {
    "default.password" = var.ADW_database_password
    "default.wallet"   = module.oci-adb[0].adb_database.adb_wallet_content
  }
  type_key = data.oci_datacatalog_catalog_types.adw_generic_connection.type_collection[0].items[0].key
}


resource "oci_datacatalog_connection" "mds_connection" {
  count          = var.create_MDS ? 1 : 0
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_mds[0].key
  display_name   = "${var.mysql_db_system_display_name}_data_connection"
  is_default     = "true"
  properties = {
    "default.username" = var.mysql_db_system_admin_username
  }
  enc_properties = {
    "default.password" = var.mysql_db_system_admin_password
  }
  type_key = data.oci_datacatalog_catalog_types.mds_jdbc_connection.type_collection[0].items[0].key
}


resource "oci_datacatalog_connection" "data_lake_connection" {
  catalog_id     = oci_datacatalog_catalog.lakehouse_catalog.id
  data_asset_key = oci_datacatalog_data_asset.lakehouse_data_asset_data_lake.key
  display_name   = "${var.data_lake_bucket_name}_data_connection"
  is_default     = "true"
  properties = {
    "default.ociCompartment" = var.compartment_ocid
    "default.ociRegion"      = var.region
  }
  type_key = data.oci_datacatalog_catalog_types.resource_principal_connection.type_collection[0].items[0].key
}

resource "oci_datacatalog_catalog_private_endpoint" "lakehouse_catalog_mysql_private_endpoint" {
  count          = var.create_MDS ? 1 : 0
  #depends_on     = [oci_identity_policy.DataCatalogReadBucketPolicy]
  compartment_id = var.compartment_ocid
  dns_zones      = ["mysqlpriv.mysqlvcn.oraclevcn.com"]
  subnet_id      = local.private_subnet_id
}

