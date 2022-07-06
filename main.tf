module "internet" {
  source = "github.com/getupcloud/terraform-module-internet?ref=v1.0"
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=v1.6"

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${var.cluster_name}/generic/manifests"
  wait           = var.flux_wait
  flux_version   = var.flux_version

  manifests_template_vars = merge(
    {
      alertmanager_cronitor_id : try(module.cronitor.cronitor_id, "")
      alertmanager_opsgenie_integration_api_key : try(module.opsgenie.api_key, "")
    },
    module.teleport-agent.teleport_agent_config,
    var.manifests_template_vars
  )
}

module "cronitor" {
  source = "github.com/getupcloud/terraform-module-cronitor?ref=v1.3"

  cronitor_enabled = var.cronitor_enabled
  cluster_name     = var.cluster_name
  customer_name    = var.customer_name
  cluster_sla      = var.cluster_sla
  suffix           = "okd"
  tags             = []
  pagerduty_key    = var.cronitor_pagerduty_key
  api_endpoint     = var.api_endpoint
}

module "opsgenie" {
  source = "github.com/getupcloud/terraform-module-opsgenie?ref=main"

  opsgenie_enabled = var.opsgenie_enabled
  customer_name    = var.customer_name
  owner_team_name  = var.opsgenie_team_name
}

module "teleport-agent" {
  source = "github.com/getupcloud/terraform-module-teleport-agent-config?ref=v0.2"

  auth_token       = var.teleport_auth_token
  cluster_name     = var.cluster_name
  customer_name    = var.customer_name
  cluster_sla      = var.cluster_sla
  cluster_provider = "generic" ##TODO: UPDATE
  cluster_region   = var.region
}
