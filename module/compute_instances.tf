resource "oci_core_instance" "gs-node" {
  count               = var.number_of_nodes
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[random_integer.ads.result], "name")
  compartment_id      = var.target_compartment_id
  shape               = var.gluster_node_shape
  create_vnic_details {
    subnet_id              = lookup(data.oci_core_subnets.dmz.subnets[0], "id")
    assign_public_ip       = "true"
    display_name           = "gs-node-${count.index}"
    hostname_label         = "gsnode${count.index}"
    skip_source_dest_check = "false"
  }
  display_name = "gs-node-${count.index}"
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
  source_details {
    source_id   = lookup(data.oci_core_images.ol_7.images[0], "id")
    source_type = "image"
  }
  preserve_boot_volume = false
}

output "private-ips" {
  value = oci_core_instance.gs-node.*.private_ip
}
