terraform {
  required_version = ">= 0.13.0"

  required_providers {
    sumologic = {
      version = "~> 2.6.2"
      source = "SumoLogic/sumologic"
    }
  }
}