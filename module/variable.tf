variable "target_compartment_id" {}
variable "vcn_compartment_id" {}
variable "ssh_public_key" {}
variable "tenancy_ocid" {}
variable "gluster_node_shape" {}
variable "gluster_arbt_shape" {}
variable "number_of_nodes" {
    type = number
    validation {
        condition     = var.number_of_nodes >= 3
        error_message = "Number of nodes must be more than 3 !"
  }
}
variable "bv_size_in_gbs" {}
variable "private_key_path" {}
variable "fs_volume_label" {}
variable "fs_dev" {}
variable "fs_mount_point" {}
variable "gs_vol_name" {}
variable "gluster_redundancy" {
    type = number
    validation {
        condition     = var.gluster_redundancy >= 1
        error_message = "Check value must be > 1 !"
  }
}

