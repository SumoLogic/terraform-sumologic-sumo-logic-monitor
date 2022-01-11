# terraform-sumologic-sumo-logic-monitor

Configure Sumo Logic Monitors using Terraform modules.

This module configures/creates monitors as per configurations.

This repository also contains predefined alerts for various technologies. Scroll to the [bottom](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor#pre-defined-monitors) of this readme to find out more details.

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
                version = ">= 2.6.2"
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

Sumo Logic monitors can be configured in a folder.

Configure the monitor folder resource as below:

```shell
resource "sumologic_monitor_folder" "tf_monitor_folder_1" {
    name = "Terraform Managed Folder"
    description = "A folder for Monitors"
}
```

In the module declaration, pass the folder id as `sumologic_monitor_folder.tf_monitor_folder_1.id`.

## Module Declaration Examples

### Logs Monitor Example

```shell
module "sumologic-logs-monitor" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  version                   = "{revision}"
  monitor_name                = "Logs Monitor"
  monitor_description         = "Sample Logs Monitor"
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
### Metrics Monitor Example

```shell
module "sumologic-metrics-monitor" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  version                   = "{revision}"
  monitor_name                = "Metrics Monitor"
  monitor_description         = "Sample Metrics Monitor"
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
## Pre-defined Monitors

- [Kubernetes](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/kubernetes)
- [Redis](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/redis)
- [Nginx](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/nginx)
- [Nginx Ingress](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/nginx-ingress)
- [PostgreSQL](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/postgresql)
- [Kafka](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/Kafka)
- [MySQL](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/mysql)
- [Apache](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/apache)
- [MongoDB](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/MongoDB)
- [SQL Server](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/SQLServer)
- [Nginx Plus](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/nginx-plus)
- [Nginx Plus Ingress](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/nginx-plus-ingress)
- [RabbitMQ](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/RabbitMQ)
- [Apache Tomcat](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/ApacheTomcat)
- [Varnish](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/Varnish)
- [HAProxy](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/blob/main/monitor_packages/haproxy)
- [Elasticsearch](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/Elasticsearch)
- [Cassandra](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/Cassandra)
- [ActiveMQ](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/ActiveMQ)
- [Memcached](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/Memcached)
- [http_response](./monitor_packages/http_response)
- [Oracle](./monitor_packages/Oracle)
