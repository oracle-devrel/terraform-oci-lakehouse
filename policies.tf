resource "oci_identity_dynamic_group" "data_catalog_dynamic_group" {
    provider       = oci.homeregion
    compartment_id = var.tenancy_ocid
    description = "Data Catalog dynamic group"
    matching_rule = "Any {resource.id = '${oci_datacatalog_catalog.lakehouse_catalog.id}'}"
    name = "data-catalog-dynamic-group"
}

resource "oci_identity_policy" "DataCatalogReadBucketPolicy" {
  provider       = oci.homeregion
  depends_on     = [oci_identity_dynamic_group.data_catalog_dynamic_group]
  name           = "DataCatalogReadBucketPolicy"
  description    = "This policy is created for the Lakehouse Data Catalog to be able to read the Data Lake bucket"
  compartment_id = var.compartment_ocid
  statements     = ["allow dynamic-group data-catalog-dynamic-group to read object-family in compartment id ${var.compartment_ocid}"]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

