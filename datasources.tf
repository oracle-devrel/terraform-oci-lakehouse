## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

data "template_file" "ad_names" {
  count    = length(data.oci_identity_availability_domains.ad.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")
}

data "oci_datacatalog_catalog_types" "resource_principal_connection" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

  filter {
    name   = "name"
    values = ["Resource Principal"]
  }
  filter {
    name   = "type_category"
    values = ["connection"]
  }
}

data "oci_datacatalog_catalog_types" "adw_generic_connection" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

  filter {
    name   = "name"
    values = ["Generic"]
  }
  filter {
    name   = "type_category"
    values = ["connection"]
  }
}

data "oci_datacatalog_catalog_types" "adw_data_asset" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

  filter {
    name   = "name"
    values = ["Autonomous Data Warehouse"]
  }
  filter {
    name   = "type_category"
    values = ["dataAsset"]
  }
}

data "oci_datacatalog_catalog_types" "objectstorage_data_asset" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

  filter {
    name   = "name"
    values = ["Oracle Object Storage"]
  }
  filter {
    name   = "type_category"
    values = ["dataAsset"]
  }
}

data "oci_datacatalog_catalog_types" "mysql_data_asset" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

  filter {
    name   = "name"
    values = ["MySQL"]
  }
  filter {
    name   = "type_category"
    values = ["dataAsset"]
  }
}

data "oci_datacatalog_catalog_types" "mds_jdbc_connection" {
  catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

  filter {
    name   = "name"
    values = ["JDBC"]
  }
  filter {
    name   = "type_category"
    values = ["connection"]
  }
}