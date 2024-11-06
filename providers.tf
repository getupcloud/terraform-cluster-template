provider "kubernetes" {
  config_path = var.use_kubeconfig ? local.kubeconfig_filename : null
  #  host                   = var.use_kubeconfig ? null : local.api_endpoint
  #  token                  = var.use_kubeconfig ? null : local.token
  #  cluster_ca_certificate = var.use_kubeconfig ? null : local.certificate_authority_data
}

provider "kubectl" {
  apply_retry_count = 2
  load_config_file  = var.use_kubeconfig
  #  host                   = var.use_kubeconfig ? null : local.api_endpoint
  #  token                  = var.use_kubeconfig ? null : local.token
  #  cluster_ca_certificate = var.use_kubeconfig ? null : local.certificate_authority_data
}
