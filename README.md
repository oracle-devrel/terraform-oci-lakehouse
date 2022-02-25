# terraform-oci-lakehouse

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-lakehouse)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-lakehouse)

This repository aims to automate the creation and integration of the multiple elements of a data lakehouse architecture.  
The current version of the code includes:
- Oracle Autonomous Data Warehouse  
(when create_ADW = true; default = true) 
- OCI MySQL DB System with HeatWave (optional)
(when create_MDS = true; default = false)
- OCI Object Storage as Data Lake
- OCI Data Catalog, including the creation of Data Assets and Connections to ADW and Data Lake 

## Architecture Diagram

![](./images/data_lakehouse.png)

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `buckets`, `database-family`, `virtual-network-family` (when creating a MySQL DB System), `data-catalog-family`.

- Quota to create the following resources: 1 ADW (if applicable), 1 MySQL DB System (if applicable), 1 Object Storage bucket, 1 Data Catalog.

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## Known Issues

There is a [bug](https://github.com/terraform-providers/terraform-provider-oci/issues/1540) in the creation of the Data Catalog Private Endpoint which is necessary for MySQL DB System connectivity. The problem exists when using Resource Manager and Cloud Shell, but it is not found when using a local OCI CLI setup.  
The code currently has a variable `using_local_OCI_CLI` which defaults to 'true' in variables.tf, but to 'false' in orm/variables.tf, which is the one present in the release build (.zip file) and Deploy to Oracle Cloud button.
When using ORM or Cloud Shell, if choosing to deploy a MySQL DB System, we recommend a manual deployment and attachment of the Data Catalog Private Endpoint.  

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-lakehouse/releases/latest/download/terraform-oci-lakehouse-stack-latest.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**.

## Deploy Using the Terraform CLI

### Clone the Module
Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/oracle-devrel/terraform-oci-lakehouse.git
    cd terraform-oci-lakehouse
    ls
  
### Set Up and Configure Terraform

1. Complete the prerequisites described [here](https://github.com/cloud-partners/oci-prerequisites).

2. Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<fingerprint>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
compartment_ocid = "<compartment_ocid>"
````

### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## Sample Lakehouse queries
### Query your Data Lake and Data Warehouse simultaneously
Refer to [this file](dcat-sync-key-steps.sql) for setup commands and joint queries, which can be executed from Oracle Machine Learning within ADW and can simultanously retrieve data from ADW and from Data Lake (Object Storage).

## Deploy as a module
You can utilize this repository as remote module, providing the necessary inputs:

```
module "oci-lakehouse" {
  source             = "github.com/oracle-devrel/terraform-oci-lakehouse"
  tenancy_ocid       = "<tenancy_ocid>"
  user_ocid          = "<user_ocid>"
  fingerprint        = "<user_ocid>"
  region             = "<oci_region>"
  private_key_path   = "<private_key_path>"
  compartment_ocid   = "<compartment_ocid>"
}
```

See [variables.tf](variables.tf) for additional variables you can optionally pass into the module if wanting to change the default values.

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.