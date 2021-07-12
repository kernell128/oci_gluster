resource "oci_core_volume" "block_vol_gs" {
  count               = var.number_of_nodes
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[random_integer.ads.result], "name")
  compartment_id      = var.target_compartment_id
  display_name        = "gs-vol-${count.index}"
  size_in_gbs         = var.bv_size_in_gbs
}
resource "oci_core_volume_attachment" "attach_vol_gs" {
  count           = var.number_of_nodes
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.gs-node[count.index].id
  volume_id       = oci_core_volume.block_vol_gs[count.index].id
  device          = count.index == 0 ? "/dev/oracleoci/oraclevdb" : null
  use_chap        = true
}
