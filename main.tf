terraform {
  required_providers {
    // OCI Provider min version
    oci = {
      source  = "hashicorp/oci"
      version = "~>4.33.0"
    }
    null = "~>2.1.2"
  }
  required_version = "~>1.0.1"
}
locals {
  tenancy_ocid          = var.tenancy_ocid
  target_compartment_id = var.target_compartment_id
  vcn_compartment_id    = var.vcn_compartment_id
  ssh_public_key        = var.ssh_public_key
  private_key_path      = var.private_key_path
  gluster_node_shape    = var.gluster_node_shape
  gluster_arbt_shape    = var.gluster_arbt_shape
  number_of_nodes       = var.number_of_nodes
  bv_size_in_gbs        = var.bv_size_in_gbs
  fs_volume_label       = var.fs_volume_label
  fs_dev                = var.fs_dev
  fs_mount_point        = var.fs_mount_point
  gs_vol_name           = var.gs_vol_name

}
module "oci_gluster" {
  /*
    Deploy Gluster in OCI
  */
  source                = "./module"
  tenancy_ocid          = local.tenancy_ocid
  target_compartment_id = local.target_compartment_id
  vcn_compartment_id    = local.vcn_compartment_id
  ssh_public_key        = local.ssh_public_key
  private_key_path      = local.private_key_path
  gluster_node_shape    = local.gluster_node_shape
  gluster_arbt_shape    = local.gluster_arbt_shape
  number_of_nodes       = local.number_of_nodes
  bv_size_in_gbs        = local.bv_size_in_gbs
  fs_volume_label       = local.fs_volume_label
  fs_dev                = local.fs_dev
  fs_mount_point        = local.fs_mount_point
  gs_vol_name           = local.gs_vol_name
}
