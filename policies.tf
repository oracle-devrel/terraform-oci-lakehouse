## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_identity_dynamic_group" "data_catalog_dynamic_group" {
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  description    = "Data Catalog dynamic group"
  matching_rule  = "Any {resource.id = '${oci_datacatalog_catalog.lakehouse_catalog.id}',resource.compartment.id = '${var.compartment_ocid}'}"
  name           = "data-catalog-dynamic-group-${random_id.tag.hex}"
}

resource "oci_identity_policy" "DataCatalogReadBucketPolicy" {
  provider       = oci.homeregion
  depends_on     = [oci_identity_dynamic_group.data_catalog_dynamic_group]
  name           = "DataCatalogReadBucketPolicy-${random_id.tag.hex}"
  description    = "This policy is created for the Lakehouse Data Catalog to be able to read the Data Lake bucket"
  compartment_id = var.compartment_ocid
  statements = ["Allow dynamic-group data-catalog-dynamic-group to read object-family in compartment id ${var.compartment_ocid}",
  "Allow dynamic-group data-catalog-dynamic-group to manage data-catalog-family in compartment id ${var.compartment_ocid}",
  "Allow dynamic-group data-catalog-dynamic-group to manage virtual-network-family in compartment id ${var.compartment_ocid}"]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

/*
resource "oci_identity_policy" "DataCatalogPrivateEndpointPolicy" {
  count          = var.create_MDS ? 1 : 0
  provider       = oci.homeregion
  name           = "DataCatalogPrivateEndpointPolicy"
  description    = "This policy is created for the Lakehouse Data Catalog Private Endpoint to be able to access MySQL Private Subnet"
  compartment_id = var.compartment_ocid
  statements = ["Allow any-user to use virtual-network-family in compartment id ${var.compartment_ocid} where request.resource.type = 'data-catalog-private-endpoints'"]

}*/