data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}
data "oci_core_images" "ol_7" {
  #Required
  compartment_id = var.tenancy_ocid
  #Optional
  #display_name = "${var.image_display_name}"
  operating_system         = "Oracle Linux"
  shape                    = var.gluster_node_shape
  operating_system_version = "7.9"
  #state = "${var.image_state}"
}
data "oci_core_vcns" "svc_spoke_vcn" {
  compartment_id = var.vcn_compartment_id
  display_name   = "acme"
}

data "oci_core_subnets" "dmz" {
  compartment_id = var.vcn_compartment_id
  vcn_id         = lookup(data.oci_core_vcns.svc_spoke_vcn.virtual_networks[0], "id")
  display_name   = "dmz"
}
