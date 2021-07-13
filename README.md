# OCI Gluster
![version][version-img]<br>
## Overview

This code was developed use terraform. Also package as a module that can be used to deploy at your terraform plans.
The final state is creating a GlusterFS cluster create and start a Gluster volume on top of this cluster. Using OCI as Cloud service provider.
This module considers an existing configured network  with access to yum repositories. To proper configure the module adjust the variables below as described at [SimpleSample blogpost](https://www.simplesample.tech/glusterfs-deplyment-in-oci/).<br>
![glusterfs](https://www.simplesample.tech/wp-content/uploads/2021/07/glusterfs-150x150.png)<br>
Enjoy!


<!---
[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/kernell128/oci_gluster/raw/main/deploy_2_oci/oci_gluster_terraform.zip)
--->
<!-- Markdown link & img dfn's -->
[version-img]: https://img.shields.io/badge/version-1.0-green
