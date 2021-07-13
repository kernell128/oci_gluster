locals {
  count_with_zero = (var.number_of_nodes - 1)
  volume_config =   ( var.number_of_nodes / 2 )
}

#Block 1 - Block volume phase
resource "null_resource" "gs-node-iscii" {
  count      = var.number_of_nodes
  depends_on = [oci_core_volume_attachment.attach_vol_gs]
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.gs-node[count.index].private_ip
    user        = "opc"
    private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y wget",
      "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.attach_vol_gs[count.index].iqn} -p ${oci_core_volume_attachment.attach_vol_gs[count.index].ipv4}:${oci_core_volume_attachment.attach_vol_gs[count.index].port}",
      "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.attach_vol_gs[count.index].iqn} -n node.startup -v automatic",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_vol_gs[count.index].iqn} -p ${oci_core_volume_attachment.attach_vol_gs[count.index].ipv4}:${oci_core_volume_attachment.attach_vol_gs[count.index].port} -o update -n node.session.auth.authmethod -v CHAP",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_vol_gs[count.index].iqn} -p ${oci_core_volume_attachment.attach_vol_gs[count.index].ipv4}:${oci_core_volume_attachment.attach_vol_gs[count.index].port} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.attach_vol_gs[count.index].chap_username}",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_vol_gs[count.index].iqn} -p ${oci_core_volume_attachment.attach_vol_gs[count.index].ipv4}:${oci_core_volume_attachment.attach_vol_gs[count.index].port} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.attach_vol_gs[count.index].chap_secret}",
      "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_vol_gs[count.index].iqn} -p ${oci_core_volume_attachment.attach_vol_gs[count.index].ipv4}:${oci_core_volume_attachment.attach_vol_gs[count.index].port} -l",
    ]
  }
}
#Block 2 - GlusterFS phase
resource "null_resource" "deploy_glusterfs" {
  count = var.number_of_nodes
  depends_on = [
    oci_core_instance.gs-node,
    null_resource.gs-node-iscii,
  ]
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.gs-node[count.index].private_ip
    user        = "opc"
    private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install oracle-gluster-release-el7 -y",
      "sudo yum install glusterfs-server -y",
      "sudo yum install targetcli -y",
      "sudo mkfs.xfs -f -i size=512 -L ${var.fs_volume_label} ${var.fs_dev}",
      "sudo mkdir -p ${var.fs_mount_point}",
      "sudo echo 'LABEL=${var.fs_volume_label} ${var.fs_mount_point} xfs defaults  0 0' | sudo tee -a /etc/fstab",
      "sudo mount -a",
      "sudo firewall-cmd --zone=public --add-port=24007-24008/tcp --permanent",
      "sudo firewall-cmd --zone=public --add-port=24009-24012/tcp --permanent",
      "sudo firewall-cmd --zone=public --add-port=111/tcp --permanent",
      "sudo firewall-cmd --zone=public --add-port=111/udp --permanent",
      "sudo firewall-cmd --zone=public --add-port=2049/tcp --permanent",
      "sudo firewall-cmd --permanent --add-port=3260/tcp",
      "sudo firewall-cmd --reload",
      "sudo systemctl enable --now glusterd",
    ]
  }
}
#Block 3a - GlusterFS first volume phase
resource "null_resource" "gluster_cluster_probe" {
  count = local.count_with_zero
  depends_on = [
    null_resource.deploy_glusterfs,
  ]
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.gs-node[0].private_ip
    user        = "opc"
    private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo gluster peer probe gsnode${(count.index + 1)}",
    ]
  }
}

#Block 3b - GlusterFS first volume phase
resource "null_resource" "deploy_gluster_volume" {
  depends_on = [
    null_resource.gluster_cluster_probe,
  ]
  connection {
    agent       = false
    timeout     = "30m"
    host        = oci_core_instance.gs-node[0].private_ip
    user        = "opc"
    private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
    inline = [
      "echo \"2\" | sudo gluster volume create ${var.gs_vol_name} disperse ${var.number_of_nodes} redundancy ${var.gluster_redundancy} gsnode{0..${local.count_with_zero}}:${var.fs_mount_point}/${var.gs_vol_name} force",
      "sudo gluster volume start ${var.gs_vol_name}",
    ]
  }
}
