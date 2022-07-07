locals {
  kubeconfig_filename        = abspath(pathexpand(var.kubeconfig_filename))
  api_endpoint               = var.api_endpoint
  token                      = var.auth_token
  certificate_authority_data = base64decode(var.certificate_authority_data)

  suffix = random_string.suffix.result
  secret = random_string.secret.result

  ##TODO: UPDATE
  PROVIDER_modules        = merge(var.PROVIDER_modules_defaults, var.PROVIDER_modules)
  PROVIDER_modules_output = {}
}
