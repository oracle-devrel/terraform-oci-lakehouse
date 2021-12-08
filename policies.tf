resource "oci_identity_policy" "DataFlow" {
  provider = oci.homeregion
  #  depends_on     = [oci_identity_policy.FunctionsServiceReposAccessPolicy]
  name           = "FunctionsDevelopersManageAccessPolicy-${random_id.tag.hex}"
  description    = "FunctionsDevelopersManageAccessPolicy-${random_id.tag.hex}"
  compartment_id = var.compartment_ocid
  statements = ["Allow group Administrators to manage functions-family in compartment id ${var.compartment_ocid}",
  "Allow group Administrators to read metrics in compartment id ${var.compartment_ocid}"]
  provisioner "local-exec" {
    command = "sleep 5"
  }
}