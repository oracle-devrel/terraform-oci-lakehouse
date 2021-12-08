data "oci_objectstorage_namespace" "bucket_namespace" {
    compartment_id  = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "datalake" {
    compartment_id        = var.compartment_ocid
    name                  = "datalake"
    namespace             = data.oci_objectstorage_namespace.bucket_namespace.namespace
    object_events_enabled = false
}

resource "oci_objectstorage_bucket" "dataflow-logs" {
    compartment_id        = var.compartment_ocid
    name                  = "dataflow-logs"
    namespace             = data.oci_objectstorage_namespace.bucket_namespace.namespace
    object_events_enabled = false
}

resource "oci_objectstorage_bucket" "dataflow-warehouse" {
    compartment_id        = var.compartment_ocid
    name                  = "dataflow-warehouse"
    namespace             = data.oci_objectstorage_namespace.bucket_namespace.namespace
    object_events_enabled = false
}