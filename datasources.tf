data "oci_datacatalog_catalog_types" "resource_principal_connection" {
    catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

    filter {
        name = "name"
        values = ["Resource Principal"]
    }
    filter {
        name = "type_category"
        values = ["connection"]
    }
}

data "oci_datacatalog_catalog_types" "adw_generic_connection" {
    catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

    filter {
        name = "name"
        values = ["Generic"]
    }
    filter {
        name = "type_category"
        values = ["connection"]
    }
}

data "oci_datacatalog_catalog_types" "adw_data_asset" {
    catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

    filter {
        name = "name"
        values = ["Autonomous Data Warehouse"]
    }
    filter {
        name = "type_category"
        values = ["dataAsset"]
    }
}

data "oci_datacatalog_catalog_types" "objectstorage_data_asset" {
    catalog_id = oci_datacatalog_catalog.lakehouse_catalog.id

    filter {
        name = "name"
        values = ["Oracle Object Storage"]
    }
    filter {
        name = "type_category"
        values = ["dataAsset"]
    }
}