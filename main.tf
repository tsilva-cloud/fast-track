
      // Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.
      // Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
      terraform {
        required_version = ">= 0.12.0"
      }

      resource "random_string" "autonomous_data_warehouse_admin_password" {
        length      = 16
        min_numeric = 1
        min_lower   = 1
        min_upper   = 1
        min_special = 1
      }
      
      data "oci_database_autonomous_db_versions" "test_autonomous_dw_versions" {
        #Required
        compartment_id = var.compartment_ocid
      
        #Optional
        db_workload = var.autonomous_data_warehouse_db_workload
      }
      
      resource "oci_database_autonomous_database" "autonomous_data_warehouse" {
        #Required
        admin_password           = random_string.autonomous_data_warehouse_admin_password.result
        compartment_id           = var.compartment_ocid
        cpu_core_count           = "1"
        data_storage_size_in_tbs = "1"
        db_name                  = var.autonomous_data_warehouse_db_name
      
        #Optional
        db_version              = data.oci_database_autonomous_db_versions.test_autonomous_dw_versions.autonomous_db_versions.1.version
        db_workload             = var.autonomous_data_warehouse_db_workload
        display_name            = var.autonomous_data_warehouse_display_name
        is_auto_scaling_enabled = "false"
        license_model           = var.autonomous_database_license_model
      }
      
      data "oci_database_autonomous_databases" "autonomous_data_warehouses" {
        #Required
        compartment_id = var.compartment_ocid
      
        #Optional
        display_name = oci_database_autonomous_database.autonomous_data_warehouse.display_name
        db_workload  = var.autonomous_data_warehouse_db_workload
      }
      
      output "autonomous_data_warehouse_admin_password" {
        value = random_string.autonomous_data_warehouse_admin_password.result
      }
      
      output "autonomous_data_warehouse_high_connection_string" {
        value = lookup(oci_database_autonomous_database.autonomous_data_warehouse.connection_strings.0.all_connection_strings, "high", "unavailable")
      }
      
      output "autonomous_data_warehouses" {
        value = data.oci_database_autonomous_databases.autonomous_data_warehouses.autonomous_databases
      }

      resource "random_string" "autonomous_database_admin_password" {
        length      = 16
        min_numeric = 1
        min_lower   = 1
        min_upper   = 1
        min_special = 1
      }
      
      data "oci_database_autonomous_db_versions" "test_autonomous_db_versions" {
        #Required
        compartment_id = var.compartment_ocid
      
        #Optional
        db_workload = var.autonomous_database_db_workload
      }
      
      resource "oci_database_autonomous_database" "autonomous_database" {
        #Required
        admin_password           = random_string.autonomous_database_admin_password.result
        compartment_id           = var.compartment_ocid
        cpu_core_count           = "1"
        data_storage_size_in_tbs = "1"
        db_name                  = var.autonomous_database_db_name
      
        #Optional
        db_version                                     = data.oci_database_autonomous_db_versions.test_autonomous_db_versions.autonomous_db_versions.1.version
        db_workload                                    = var.autonomous_database_db_workload
        display_name                                   = var.autonomous_database_display_name
        is_auto_scaling_enabled                        = "true"
        license_model                                  = var.autonomous_database_license_model
        is_preview_version_with_service_terms_accepted = "false"
        whitelisted_ips                                = ["1.1.1.1/28"]
      }
      
      
      data "oci_database_autonomous_databases" "autonomous_databases" {
        #Required
        compartment_id = var.compartment_ocid
      
        #Optional
        display_name = oci_database_autonomous_database.autonomous_database.display_name
        db_workload  = var.autonomous_database_db_workload
      }
      
      output "autonomous_database_admin_password" {
        value = random_string.autonomous_database_admin_password.result
      }
      
      output "autonomous_database_high_connection_string" {
        value = lookup(oci_database_autonomous_database.autonomous_database.connection_strings.0.all_connection_strings, "high", "unavailable")
      }
      
      output "autonomous_databases" {
        value = data.oci_database_autonomous_databases.autonomous_databases.autonomous_databases
      }

      resource "random_string" "autonomous_database_wallet_password" {
        length  = 16
        special = true
      }
      
      data "oci_database_autonomous_database_wallet" "autonomous_database_wallet" {
        autonomous_database_id = oci_database_autonomous_database.autonomous_database.id
        password               = random_string.autonomous_database_wallet_password.result
        base64_encode_content  = "true"
      }
      
      output "autonomous_database_wallet_password" {
        value = random_string.autonomous_database_wallet_password.result
      }
    