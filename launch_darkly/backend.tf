terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "2.1.1"
    }
  }

  backend "azurerm" {
  }
}
