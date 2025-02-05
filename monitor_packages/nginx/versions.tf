terraform {
  required_version = ">= 0.13.0"

  required_providers {
    sumologic = {
      version = ">= 2.31.3"
      source = "SumoLogic/sumologic"
    }
  }
}
