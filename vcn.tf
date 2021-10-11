resource "oci_core_vcn" "terraformVCN" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "terraformVCN"
  dns_label      = "terraformVCN"
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "TestInternetGateway"
  vcn_id         = oci_core_vcn.terraformVCN.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.terraformVCN.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_subnet" "terraformSUBNET" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.0.0.0/24"
  display_name        = "terraformSUBNET"
  dns_label           = "terraformSUBNET"
  security_list_ids   = [oci_core_vcn.terraformVCN.default_security_list_id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.terraformVCN.id
  route_table_id      = oci_core_vcn.terraformVCN.default_route_table_id
  dhcp_options_id     = oci_core_vcn.terraformVCN.default_dhcp_options_id
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}
