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

Configure the Sumo Logic Access Key, Access Id and Deployment in the file `nginx.auto.tfvars`.

```shell
  access_id   = "<SUMOLOGIC ACCESS ID>"
  access_key  = "<SUMOLOGIC ACCESS KEY>"
  environment = "<SUMOLOGIC DEPLOYMENT>"
```
The monitors are disabled by default on installation, if you would like to enable all the monitors, set the flag `monitors_disabled` as `false` in `nginx.auto.tfvars`.
By default the monitors are installed in a folder named as `Nginx`, if you want to change the folder name, set the variable `folder` in the file `nginx.auto.tfvars`.

### Installation Steps

* Make sure that `Terraform 0.13+` is installed.
* Run `terraform init`.
* Configure `Sumo Logic Authentication` details in the file `nginx.auto.tfvars` as explained in the previous step.
* Optionally, update the monitor folder name in the file ``nginx.auto.tfvars``.
* Based on your requirement, enable or disable all the monitors by setting the flag `monitors_disabled` in `nginx.auto.tfvars`.
* Configure Email and Connection notifications in the file `nginx.auto.tfvars`.
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
|Metrics|Nginx - Dropped Connections|This alert fires when we detect dropped connections for a given Nginx server.|Critical|
|Logs|Nginx - Access from Highly Malicious Source|This alert fires when an Nginx is accessed from highly malicious IP addresses.|Critical|
|Logs|Nginx - Critical Error Messages|This alert fires when we detect critical error messages for a given Nginx server.|Critical|
|Logs|Nginx - High Client (HTTP 4xx) Error Rate|This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx.|Critical|
|Logs|Nginx - High Server (HTTP 5xx) Error Rate|This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx.|Critical|
