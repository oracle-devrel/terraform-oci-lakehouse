module "oci-adb" {
  source                                = "github.com/oracle-quickstart/oci-adb"
  adb_password                          = var.ADW_password
  compartment_ocid                      = var.compartment_ocid
  adb_database_cpu_core_count           = var.ADW_database_cpu_core_count
  adb_database_data_storage_size_in_tbs = var.ADW_database_data_storage_size_in_tbs
  adb_database_db_name                  = var.ADW_database_db_name
  adb_database_db_version               = var.ADW_database_db_version
  adb_database_display_name             = var.ADW_database_display_name
  adb_database_freeform_tags            = var.ADW_database_freeform_tags
  adb_database_license_model            = var.ADW_database_license_model
  adb_database_db_workload              = "DW"
  use_existing_vcn                      = false
  adb_private_endpoint                  = false
  defined_tags                          = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
