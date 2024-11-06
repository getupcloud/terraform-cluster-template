locals {
  kubeconfig_filename = abspath(pathexpand(var.kubeconfig_filename))

  suffix = random_string.suffix.result
  secret = random_string.secret.result

  modules_result = {
    for name, config in merge(var.modules, local.modules) : name => merge(config, {
      output : try(config.enabled, true) ? lookup(local.register_modules, name, try(config.output, tomap({}))) : tomap({})
    })
  }

  manifests_template_vars = merge(
    {
      cluster : {
        region : var.region
      }
    },
    var.manifests_template_vars,
    {
      alertmanager_cronitor_id : var.cronitor_id
      alertmanager_opsgenie_integration_api_key : var.opsgenie_integration_api_key
      secret : random_string.secret.result
      suffix : random_string.suffix.result
      modules : local.modules_result
    },
    module.teleport-agent.teleport_agent_config,
    { for k, v in var.manifests_template_vars : k => v if k != "modules" }
  )


}
