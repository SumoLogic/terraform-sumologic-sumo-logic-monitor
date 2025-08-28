terraform {
  required_version = ">= 1.5.7"

  required_providers {
    sumologic = {
      version = ">= 2.31.3"
      source = "SumoLogic/sumologic"
    }
  }
}
