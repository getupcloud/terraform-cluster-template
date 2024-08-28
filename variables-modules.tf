## Provider-specific modules variables
## Copy to toplevel

variable "modules_defaults" {
  description = "Configure Provider modules to install (defaults)"
  type = object({
    ## cert-manager = object({ enabled = bool })
    ## logging      = object({ enabled = bool })
    ## velero       = object({ enabled = bool })
  })

  default = {
    ## cert-manager = { enabled = false }
    ## logging      = { enabled = true }
    ## velero       = { enabled = true }
  }
}

locals {
  register_modules = {
    ## cert-manager : local.modules.cert-manager.enabled ? module.cert-manager[0] : {}
    ## logging : local.modules.logging.enabled ? module.logging[0] : {}
    ## velero : local.modules.velero.enabled ? module.velero[0] : {}
  }
}
