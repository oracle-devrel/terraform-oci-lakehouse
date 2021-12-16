data "oci_objectstorage_namespace" "bucket_namespace" {
    compartment_id  = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "data_lake" {
    compartment_id        = var.compartment_ocid
    name                  = var.data_lake_bucket_name
    namespace             = data.oci_objectstorage_namespace.bucket_namespace.namespace
    object_events_enabled = false
}

resource "oci_objectstorage_preauthrequest" "data_lake_par" {
    access_type = var.data_lake_preauth_request_access_type
    bucket = oci_objectstorage_bucket.data_lake.name
    bucket_listing_action = var.data_lake_preauth_request_bucket_listing_action
    name = "data-lake-par"
    namespace = data.oci_objectstorage_namespace.bucket_namespace.namespace
    time_expires = var.data_lake_preauth_request_time_expires
}
