
resource "oci_identity_policy" "DataFlow" {
  provider = oci.homeregion
  name           = "DataFlowAdmin"
  description    = "DataFlowAdmin"
  compartment_id = var.compartment_ocid
  statements = ["Allow group data-flow-admin to read buckets in compartment id ${var.compartment_ocid}",
"Allow group data-flow-admin to manage dataflow-family in compartment id ${var.compartment_ocid}",
"Allow group data-flow-admin to manage objects in compartment id ${var.compartment_ocid} where ALL {target.bucket.name='dataflow-logs', any {request.permission='OBJECT_CREATE', request.permission='OBJECT_INSPECT'}}"
  ]
  provisioner "local-exec" {
    command = "sleep 5"
  }
}
