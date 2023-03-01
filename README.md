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

#### Required Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_id"></a> [access\_id](#input\_access\_id) | Sumo Logic Access ID. Visit https://help.sumologic.com/Manage/Security/Access-Keys#Create_an_access_key | `string` | n/a | yes |
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Sumo Logic Access Key. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Please update with your deployment, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security | `string` | n/a | yes |
| <a name="input_sumologic_organization_id"></a> [sumologic\_organization\_id](#input\_sumologic\_organization\_id) | You can find your org on the Preferences page in the Sumo Logic UI.<br>            For more details, visit https://help.sumologic.com/01Start-Here/05Customize-Your-Sumo-Logic-Experience/Preferences-Page | `string` | n/a | yes |

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
                  threshold             = 5,
                  time_range            = "5m",
                  occurrence_type       = "ResultCount", # Options: ResultCount and MissingData for logs
                  trigger_source        = "AllResults", # Options: AllResults for logs.
                  trigger_type          = "Critical",
                  detection_method      = "StaticCondition"
                },
                {
                  threshold_type        = "LessThan",
                  threshold             = 5,
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
- [IIS](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/IIS)
- [MariaDB](./monitor_packages/MariaDB)
- [Oracle](./monitor_packages/Oracle)
- [Squid Proxy](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/SquidProxy)
- [Couchbase](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/tree/main/monitor_packages/Couchbase)

## Resources

| Name | Type |
|------|------|
| [sumologic_monitor.tf_monitor](https://registry.terraform.io/providers/SumoLogic/sumologic/latest/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_notifications"></a> [connection\_notifications](#input\_connection\_notifications) | Connection Notifications to be sent by the alert. | <pre>list(object(<br>                {<br>                  connection_type = string,<br>                  connection_id = string,<br>                  payload_override = string,<br>                  run_for_trigger_types = list(string)<br>                }<br>    ))</pre> | n/a | yes |
| <a name="input_email_notifications"></a> [email\_notifications](#input\_email\_notifications) | Email Notifications to be sent by the alert. | <pre>list(object(<br>                {<br>                  connection_type = string,<br>                  recipients = list(string),<br>                  subject = string,<br>                  time_zone = string,<br>                  message_body = string,<br>                  run_for_trigger_types = list(string)<br>                }<br>    ))</pre> | n/a | yes |
| <a name="input_group_notifications"></a> [group\_notifications](#input\_group\_notifications) | Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true. | `bool` | `true` | no |
| <a name="input_monitor_description"></a> [monitor\_description](#input\_monitor\_description) | The description of the monitor. | `string` | `""` | no |
| <a name="input_monitor_evaluation_delay"></a> [monitor\_evaluation\_delay](#input\_monitor\_evaluation\_delay) | Evaluation Delay. | `string` | `"0m"` | no |
| <a name="input_monitor_is_disabled"></a> [monitor\_is\_disabled](#input\_monitor\_is\_disabled) | Whether or not the monitor is disabled. Default false. | `bool` | `false` | no |
| <a name="input_monitor_monitor_type"></a> [monitor\_monitor\_type](#input\_monitor\_monitor\_type) | The type of monitor, Logs or Metrics. Default Logs | `string` | `"Logs"` | no |
| <a name="input_monitor_name"></a> [monitor\_name](#input\_monitor\_name) | Monitor Name | `string` | n/a | yes |
| <a name="input_monitor_parent_id"></a> [monitor\_parent\_id](#input\_monitor\_parent\_id) | The ID of the Monitor Folder that contains this monitor. | `string` | `null` | no |
| <a name="input_monitor_permission"></a> [monitor\_permission](#input\_monitor\_permission) | An monitor\_permission is used to control permissions Explicitly associated with a Monitor | <pre>list(object(<br>                {<br>                  subject_type = string,<br>                  subject_id = string,<br>                  permissions = list(string)<br>                }<br>    ))</pre> | `[]` | no |
| <a name="input_monitor_slo_id"></a> [monitor\_slo\_id](#input\_monitor\_slo\_id) | Slo Id. Required if Monitor Type is Slo. | `string` | `null` | no |
| <a name="input_monitor_slo_type"></a> [monitor\_slo\_type](#input\_monitor\_slo\_type) | The type of Slo, Sli or BurnRate. Required if Monitor Type is Slo. | `string` | `null` | no |
| <a name="input_queries"></a> [queries](#input\_queries) | All queries for the monitor. | `map` | `null` | no |
| <a name="input_slo_burnrate_triggers"></a> [slo\_burnrate\_triggers](#input\_slo\_burnrate\_triggers) | Triggers for SLO Burn Rate alerting. | <pre>list(object(<br>                {<br>                  threshold = number,<br>                  time_range = string,<br>                  trigger_type = string,<br>                }<br>    ))</pre> | `null` | no |
| <a name="input_slo_sli_triggers"></a> [slo\_sli\_triggers](#input\_slo\_sli\_triggers) | Triggers for SLO Sli alerting. | <pre>list(object(<br>                {<br>                  threshold = number,<br>                  trigger_type = string,<br>                }<br>    ))</pre> | `null` | no |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | Triggers for alerting. | <pre>list(object(<br>                {<br>                  threshold_type = string,<br>                  threshold = number,<br>                  time_range = string,<br>                  occurrence_type = string,<br>                  trigger_source = string,<br>                  trigger_type = string,<br>                  detection_method = string<br>                }<br>    ))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sumologic_monitor"></a> [sumologic\_monitor](#output\_sumologic\_monitor) | This output contains details of the Sumo Logic monitor. |
