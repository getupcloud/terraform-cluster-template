## Common variables

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "customer_name" {
  description = "Customer name"
  type        = string
}

variable "cluster_sla" {
  description = "Cluster SLA"
  type        = string
  default     = "none"
}

variable "use_kubeconfig" {
  description = "Should kubernetes/kubectl providers use local kubeconfig or credentials from cloud module"
  type        = bool
  default     = false
}

##TODO: UPDATE
## This may be already required by cloud provider
variable "region" {
  description = "Cluster Region"
  type        = string
}

variable "kubeconfig_filename" {
  description = "Kubeconfig path"
  default     = "~/.kube/config"
  type        = string
}

variable "get_kubeconfig_command" {
  description = "Command to create/update kubeconfig"
  type        = string
  default     = "true"
}

variable "flux_git_repo" {
  description = "GitRepository URL."
  type        = string
  default     = ""
}

variable "flux_wait" {
  description = "Wait for all manifests to apply"
  type        = bool
  default     = true
}

variable "flux_version" {
  description = "Flux version to install"
  type        = string
  default     = "v0.15.3"
}

variable "manifests_path" {
  description = "Manifests dir inside GitRepository"
  type        = string
  default     = ""
}

variable "cronitor_enabled" {
  description = "Creates and enables Cronitor monitor."
  type        = bool
  default     = false
}
variable "cronitor_pagerduty_key" {
  description = "Cronitor PagerDuty key"
  type        = string
  default     = ""
}

variable "opsgenie_enabled" {
  description = "Creates and enables Opsgenie integration."
  type        = bool
  default     = false
}

variable "opsgenie_team_name" {
  description = "Opsgenie Owner team name of the integration."
  type        = string
  default     = "Operations"
}

variable "api_endpoint" {
  description = "Kubernetes API endpoint"
  type        = string
  default     = "https://localhost:6443"
}

variable "auth_token" {
  description = "Kubernetes auth token"
  type        = string
  default     = null
}

variable "certificate_authority_data" {
  description = "Kubernetes CA data as base64"
  type        = string
  default     = null
}


variable "manifests_template_vars" {
  description = "Template vars for use by cluster manifests"
  type        = any
  default = {
    alertmanager_pagerduty_key : ""
  }
}

variable "teleport_auth_token" {
  description = "Teleport Agent auth token"
  type        = string
  default     = ""
}
