## Provider specific variables
## Copy to toplevel

variable "region" {
  description = "Provider Region"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "Provider VPC ID. Example: vpc-xxxxxxxxxxxxxxxxx"
  type        = string
}

variable "subnet_ids" {
  description = "Provider VPC subnet IDs. Applies to all node_groups by default. Example: [\"subnet-xxxxxxxxxxxxxxxxx\",\"subnet-yyyyyyyyyyyyyyyyy\"]"
  type        = list(string)
}

#############################
## Node Groups
#############################

variable "node_groups_defaults" {
  description = "Provider default node_groups definition"
  type        = any
  default = {
    instance_types   = ["m5.xlarge"]
    desired_capacity = 1
    min_capacity     = 1
    max_capacity     = 1
    disk_size        = 50
    additional_tags  = {}

    # To use kubelet_extra_args you must set create_launch_template=true.
    # kubelet_extra_args : "--max-pods=110"
    # create_launch_template: true
  }

  validation {
    condition     = length(var.node_groups_defaults.instance_types) > 0
    error_message = "Missing instance_types[]. Ex: [\"m5.xlarge\"]."
  }
}

variable "node_groups" {
  description = "Provider node_groups definition"
  type        = any
  default = {
    "infra" : {
      "min_capacity" : 2
      "max_capacity" : 2
      "k8s_labels" : {
        "role" : "infra"
      }
      "taints" : [
        {
          "key" : "dedicated"
          "value" : "infra"
          "effect" : "NO_SCHEDULE"
        }
      ]

      # To use kubelet_extra_args you must set create_launch_template=true.
      # kubelet_extra_args : "--max-pods=110"
      # create_launch_template: true
    }
    "app" : {
      "min_capacity" : 2
      "max_capacity" : 4
      "k8s_labels" : {
        "role" : "app"
      }

      # To use kubelet_extra_args you must set create_launch_template=true.
      # kubelet_extra_args : "--max-pods=110"
      # create_launch_template: true
    }
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = any
  default     = {}
}

variable "cluster_tags" {
  description = "A map of additional tags to add to the cluster"
  type        = any
  default     = {}
}
