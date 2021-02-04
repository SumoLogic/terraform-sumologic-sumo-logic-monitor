# sumologic-nginx-monitors

This script configures Sumo Logic Monitors for Nginx using Terraform modules.

## Getting Started

### Requirements

* [Terraform 0.13+](https://www.terraform.io/downloads.html)
* [Sumo Logic Provider](https://registry.terraform.io/providers/SumoLogic/sumologic/latest/docs)
* [Sumo Logic Monitors Module](https://registry.terraform.io/modules/SumoLogic/sumo-logic-monitor/sumologic/latest)


The `versions.tf` file lists the requirements.
Running `terraform init` will automatically install the required providers and the required modules.


### Sumo Logic Provider

Configure the Sumo Logic Access Key, Access Id and Deployment in the file `sumologic_provider_and_monitors_folder`.

```shell
provider "sumologic" {
  access_id   = "<SUMOLOGIC ACCESS ID>"
  access_key  = "<SUMOLOGIC ACCESS KEY>"
  environment = "<SUMOLOGIC DEPLOYMENT>"
}
```
You can also define these values in `terraform.tfvars`.

### Installation Steps

* Make sure that `Terraform 0.13+` is installed.
* Run `terraform init`.
* Configure `Sumo Logic Provider` in the file `sumologic_provider_and_monitors_folder.tf` as explained in the previous step.
* Optionally, update the monitor folder name in the file `sumologic_provider_and_monitors_folder.tf`.
* Configure Email and Connection notifications in the file `nginx_notifications.auto.tfvars`.
* Run `terraform plan` to view the resources which will be created/modified by Terraform.
* Run `terraform apply`.

### Sample Email and Connection Notification Configuration File Values

```shell
group_notifications = true
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

### Monitors Created

| Type (Metrics/Logs)|Name|Description|Trigger Type (Critical / Warning / MissingData)|
|---|---|---|---|
|Metrics|Instance down|This alert fires when the Redis instance is down.|MissingData|
|Metrics|High CPU Usage|This alert is fired if user and system cpu usage for a host exceeds 80%.|Critical|
|Metrics|Mem Fragmentation Ratio Higher than 1.5|Compares Compares Redis memory usage to Linux virtual memory pages (mapped to physical memory chunks). A high ratio will lead to swapping and performance degradation.|Warning|
|Metrics|Master-Slave IO|It has been 60 seconds that the io between master and slave was down.|Warning|
|Metrics|Missing master|This alert fires when we detect that a Redis cluster has no node marked as master.|Critical|
