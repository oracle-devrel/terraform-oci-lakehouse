data "oci_objectstorage_namespace" "bucket_namespace" {
    compartment_id  = var.compartment_ocid
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

resource "oci_objectstorage_bucket" "data_lake" {
    compartment_id        = var.compartment_ocid
    name                  = var.data_lake_bucket_name
    namespace             = data.oci_objectstorage_namespace.bucket_namespace.namespace
    object_events_enabled = false
}

resource "oci_objectstorage_preauthrequest" "data_lake_par" {
    #Required
    access_type = var.data_lake_preauth_request_access_type
    bucket = oci_objectstorage_bucket.data_lake.name
    bucket_listing_action = var.data_lake_preauth_request_bucket_listing_action
    name = "data-lake-par"
    namespace = data.oci_objectstorage_namespace.bucket_namespace.namespace
    time_expires = var.data_lake_preauth_request_time_expires

}

resource "oci_objectstorage_object" "test_object" {
    bucket = oci_objectstorage_bucket.data_lake.name
    namespace = data.oci_objectstorage_namespace.bucket_namespace.namespace
    source = "~/shakespeare.json"
    object = "shakespeare.json"
}

resource "oci_objectstorage_object" "test_object2" {
    bucket = oci_objectstorage_bucket.data_lake.name
    namespace = data.oci_objectstorage_namespace.bucket_namespace.namespace
    source = "~/citibike-tripdata.csv"
    object = "citibike-tripdata.csv"
}

