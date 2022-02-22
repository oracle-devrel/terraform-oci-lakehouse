## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oci-adb" {
  count                                 = var.create_ADW ? 1 : 0
  depends_on                            = [oci_identity_dynamic_group.data_catalog_dynamic_group]
  source                                = "github.com/oracle-devrel/terraform-oci-arch-adb"
  adb_password                          = var.ADW_database_password
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

module "mds-instance" {
    count                                           = var.create_MDS ? 1 : 0
    source                                          = "github.com/oracle-devrel/terraform-oci-cloudbricks-mysql-database"
    tenancy_ocid                                    = var.tenancy_ocid
    user_ocid                                       = var.user_ocid
    fingerprint                                     = var.fingerprint
    private_key_path                                = var.private_key_path
    region                                          = var.region
    mysql_instance_compartment_ocid                 = var.compartment_ocid
    mysql_network_compartment_ocid                  = var.compartment_ocid
    subnet_id                                       = local.private_subnet_id    
    mysql_db_system_admin_username                  = var.mysql_db_system_admin_username
    mysql_db_system_admin_password                  = var.mysql_db_system_admin_password
    mysql_db_system_availability_domain             = data.template_file.ad_names.*.rendered[0]
    mysql_db_system_data_storage_size_in_gb         = var.mysql_db_system_data_storage_size_in_gb
    mysql_db_system_defined_tags                    = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    mysql_db_system_description                     = var.mysql_db_system_description
    mysql_db_system_display_name                    = var.mysql_db_system_display_name
    mysql_db_system_fault_domain                    = var.mysql_db_system_fault_domain
    mysql_db_system_hostname_label                  = var.mysql_db_system_hostname_label
    mysql_db_system_maintenance_window_start_time   = var.mysql_db_system_maintenance_window_start_time
    mysql_db_system_is_highly_available             = var.deploy_mds_ha
    mysql_heatwave_enabled                          = var.mysql_heatwave_enabled
    mysql_shape_name                                = var.mysql_heatwave_enabled ? var.mysql_heatwave_shape : var.mysql_shape
}