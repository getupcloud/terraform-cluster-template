terraform {
  required_providers {
    aws = {
      version = ">= 3.56.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1"
    }

    kubernetes = {
      version = "~> 2.8"
    }

    kustomization = {
      source  = "kbst/kustomization"
      version = "< 1"
    }

    random = {
      version = "~> 2"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1"
    }
  }
}

provider "kustomization" {
  kubeconfig_raw = ""
}

provider "aws" {
  region     = "sa-east-1"
  access_key = "aws_access_key_id"
  secret_key = "aws_secret_access_key"
}

module "cluster" {
  source = "../"

  region = "sa-east-1"
  cluster_name = "cluster_name"
  customer_name = "customer_name"

  vpc_id = "vpc_id"
  subnet_ids = ["subnet_ids"]
}
