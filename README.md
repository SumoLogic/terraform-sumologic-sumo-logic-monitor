# terraform-sumologic-sumo-logic-monitor

Configure Sumo Logic Alerts using Terraform modules.

The modules configure/create alerts as per configurations.

## Getting Started

#### Requirements

* [Terraform 0.13+](https://www.terraform.io/downloads.html)
* [Sumo Logic Provider](https://registry.terraform.io/providers/SumoLogic/sumologic/latest/docs)


    Create a `versions.tf` file and add the requirements in the following format:

    ```shell
    terraform {
      required_version = ">= 0.13"

      required_providers {
           sumologic = {
                version = "~> 2.6.2"
                source = "SumoLogic/sumologic"
        }
      }
    }
    ```

#### Sumo Logic Provider

```shell
provider "sumologic" {
  access_id   = "<SUMOLOGIC ACCESS ID>"
  access_key  = "<SUMOLOGIC ACCESS KEY>"
  environment = "<SUMOLOGIC DEPLOYMENT>"
}
```
You can also define these values in `terraform.tfvars`.
#### Optional Prerequisites

Sumo Logic alerts can be configured in a folder.

Configure the monitor folder resource as below:

```shell
resource "sumologic_monitor_folder" "tf_monitor_folder_1" {
    name = "Terraform Managed Folder"
    description = "A folder for Monitors"
}
```

In the module declaration, pass the folder id as `sumologic_monitor_folder.tf_monitor_folder_1.id`.

## Module Declaration Examples

### Logs Alert Example

```shell
module "sumologic-logs-alert" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  version                   = "{revision}"
  alert_name                = "Logs Monitor"
  alert_description         = "Sample Logs Monitor"
  alert_monitor_type        = "Logs"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Only one query is allowed for Logs monitor
  queries = {
    A = "<Logs Query>"
  }

  # Triggers
  triggers = [
              {
                  threshold_type        = "GreaterThanOrEqual",
                  threshold             = 0,
                  time_range            = "5m",
                  occurrence_type       = "ResultCount", # Options: ResultCount and MissingData for logs
                  trigger_source        = "AllResults", # Options: AllResults for logs.
                  trigger_type          = "Critical",
                  detection_method      = "StaticCondition"
                },
                {
                  threshold_type        = "LessThan",
                  threshold             = 0,
                  time_range            = "5m",
                  occurrence_type       = "ResultCount", # Options: ResultCount and MissingData for logs
                  trigger_source        = "AllResults", # Options: AllResults for logs.
                  trigger_type          = "ResolvedCritical",
                  detection_method      = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications      = true
  connection_notifications = [
    {
      connection_type       = "PagerDuty",
      connection_id         = "<CONNECTION_ID>",
      payload_override      = "{\"service_key\": \"your_pagerduty_api_integration_key\",\"event_type\": \"trigger\",\"description\": \"Alert: Triggered {{TriggerType}} for Monitor {{Name}}\",\"client\": \"Sumo Logic\",\"client_url\": \"{{QueryUrl}}\"}",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    },
    {
      connection_type       = "Webhook",
      connection_id         = "<CONNECTION_ID>",
      payload_override      = "",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    }
  ]
  email_notifications = [
    {
      connection_type       = "Email",
      recipients            = ["abc@example.com"],
      subject               = "Monitor Alert: {{TriggerType}} on {{Name}}",
      time_zone             = "PST",
      message_body          = "Triggered {{TriggerType}} Alert on {{Name}}: {{QueryURL}}",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    }
  ]
}
```
### Metrics Alert Example

```shell
module "sumologic-metrics-alert" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  version                   = "{revision}"
  alert_name                = "Metrics Monitor"
  alert_description         = "Sample Metrics Monitor"
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries   = {
    A = "<Metric_query1>",
    B = "<Metric_query2>",
    C = "<Metric_query3>"
  }

  # Triggers
  triggers  = [
              {
                  threshold_type            = "GreaterThanOrEqual",
                  threshold                 = 0,
                  time_range                = "5m",
                  occurrence_type           = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source            = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type              = "Critical",
                  detection_method          = "StaticCondition"
                },
                {
                  threshold_type            = "LessThan",
                  threshold                 = 0,
                  time_range                = "5m",
                  occurrence_type           = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source            = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics.'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type              = "ResolvedCritical",
                  detection_method          = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications      = true
  connection_notifications = [
    {
      connection_type       = "PagerDuty",
      connection_id         = "<CONNECTION_ID>",
      payload_override      = "{\"service_key\": \"your_pagerduty_api_integration_key\",\"event_type\": \"trigger\",\"description\": \"Alert: Triggered {{TriggerType}} for Monitor {{Name}}\",\"client\": \"Sumo Logic\",\"client_url\": \"{{QueryUrl}}\"}",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    },
    {
      connection_type       = "Webhook",
      connection_id         = "<CONNECTION_ID>",
      payload_override      = "",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    }
  ]
  email_notifications = [
    {
      connection_type       = "Email",
      recipients            = ["abc@example.com"],
      subject               = "Monitor Alert: {{TriggerType}} on {{Name}}",
      time_zone             = "PST",
      message_body          = "Triggered {{TriggerType}} Alert on {{Name}}: {{QueryURL}}",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    }
  ]
}
```
