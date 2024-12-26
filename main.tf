module "internet" {
  source = "github.com/getupcloud/terraform-module-internet?ref=v1.0"
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=v2.8.3"

  git_repo                = var.flux_git_repo
  manifests_path          = "./clusters/${var.cluster_name}/generic/manifests"
  wait                    = var.flux_wait
  flux_version            = var.flux_version
  manifests_template_vars = local.manifests_template_vars
  debug                   = var.dump_debug

  depends_on = [
    shell_script.pre_create
  ]
}

module "teleport-agent" {
  source = "github.com/getupcloud/terraform-module-teleport-agent-config?ref=v0.3"

  auth_token       = var.teleport_auth_token
  cluster_name     = var.cluster_name
  customer_name    = var.customer_name
  cluster_sla      = var.cluster_sla
  cluster_provider = "generic" ##TODO: UPDATE
  cluster_region   = var.region
}
