---------------------------------------------
-- Prior to running, set up OCI policies
---------------------------------------------
-- Example
/*
Dynamic Group: data-platform-services
resource.compartment.id='ocid1.compartment.oc1..’*

Policy:  data-platform-policy
allow dynamic-group data-platform-services to read object-family in compartment data-platform
allow dynamic-group data-lake-services to manage data-catalog-family in compartment data-platform
*/
------------------------------------------------------
-- Supply connection info 
------------------------------------------------------
define dcat_region='sa-saopaulo-1'

define dcat_compartment = 'ocid1.compartment.oc1..abcdefghijklmnopqrstuvwxyz'
define dcat_ocid = 'ocid1.datacatalog.oc1.sa-saopaulo-1.abcdefghijklmnopqrstuvwxyz'

define dcat_credential = 'OCI$RESOURCE_PRINCIPAL'
define obj_credential = 'OCI$RESOURCE_PRINCIPAL'

------------------------------
-- Enable resource principal
------------------------------
exec dbms_cloud_admin.enable_resource_principal();
select * from all_credentials;

---------------------------------
-- Connect and sync
---------------------------------
-- Specify the credentials to use for connecting to object store and data catalog
exec dbms_dcat.set_data_catalog_credential(credential_name => '&dcat_credential');
exec dbms_dcat.set_object_store_credential(credential_name => '&obj_credential');

-- Set connection.  
-- This step will add custom properties to Data Catalog (e.g. "schema prefix")
begin
   dbms_dcat.set_data_catalog_conn (
     region => '&dcat_region',
     catalog_id => '&dcat_ocid');
end;
/

-- Look at the connection.  You'll see the DCAT ocid, its compartment, and credentials used to access object storage and dcat.
select * from all_dcat_connections;

-- What's available in the data catalog?
select * from all_dcat_assets; 
select * from all_dcat_folders;
select * from all_dcat_entities;

-- Run sync
begin
    dbms_dcat.run_sync(synced_objects => 
        '{"asset_list": ["*"]}');                    
end;
/

-- What can you query?
select a.folder_name, 
       a.display_name, 
       a.business_name, 
       d.oracle_schema_name, 
       d.oracle_table_name,
       a.description
from all_dcat_entities a, dcat_entities d
where a.data_asset_key = d.asset_key
and a.key = d.entity_key
order by 1,2;

------------------------------
-- Run some queries!
-- Using MovieStream Live Labs data - Find the Lab @ https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/home

------------------------------
-- Query the across internal and external data
select cs.short_name as segment,
       ce.first_name || ' ' || ce.last_name as full_name,
	   cc.state_province,
       cc.country,
       ce.age,
       ce.gender,
       ce.marital_status,
       ce.job_type,
       ce.household_size
from moviestream.customer_contact cc, 
     dcat$obj_landing.customer_segment cs, 
     dcat$obj_landing.customer_extension ce
where ce.segment_id = cs.segment_id
  and ce.cust_id = cc.cust_id;


-- Grant read to users (need to make this easier)
grant read on dcat$obj_landing.customer_segment to dwrole;


-- Done

--------------------
-- other
--------------------
-- Create a sync job
begin
    dbms_dcat.create_sync_job (
        synced_objects => '{"asset_list":["*"]}',          
        repeat_interval => 'FREQ=MINUTELY;INTERVAL=3;'
    );
end;
/

-- Sync a single asset - the sandbox
select path, display_name, key as folder_key, data_asset_key
from all_dcat_folders
where display_name='moviestream_sandbox';

-- Specify the folder key and data_asset_key returned by the previous query
begin
    dbms_dcat.run_sync(synced_objects => 
        '{"asset_list": [
            {
                "asset_id":"6d6c82a4-4c58-400a-b713-6a1e1b0cc54c",
                "folder_list":[
                    "145fbf87-c106-46dc-904e-eed3cce35c7f" 
               ]
            }   
        ]}');                    
end;
/

-- Review the log.  Logfile_Table will have the name of the table containing the full log.
select type, start_time, status, logfile_table 
from user_load_operations
order by start_time desc;  

-- use the log table associated with the latest 
select * 
from DBMS_DCAT$57_LOG 
order by log_timestamp desc;

