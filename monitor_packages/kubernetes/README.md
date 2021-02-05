# sumologic-kubernetes-monitors

This script configures Sumo Logic Monitors for Kubernetes using Terraform modules.

## Getting Started

### Requirements

* [Terraform 0.13+](https://www.terraform.io/downloads.html)
* [Sumo Logic Provider](https://registry.terraform.io/providers/SumoLogic/sumologic/latest/docs)
* [Sumo Logic Monitors Module](https://registry.terraform.io/modules/SumoLogic/sumo-logic-monitor/sumologic/latest)


The `versions.tf` file lists the requirements.
Running `terraform init` will automatically install the required providers and the required modules.


### Sumo Logic Provider

Configure the Sumo Logic Access Key, Access Id and Deployment in the file `kubernetes.auto.tfvars`.

```shell
  access_id   = "<SUMOLOGIC ACCESS ID>"
  access_key  = "<SUMOLOGIC ACCESS KEY>"
  environment = "<SUMOLOGIC DEPLOYMENT>"
```
The monitors are disabled by default on installation, if you would like to enable all the monitors, set the flag `monitors_disabled` as `false` in `kubernetes.auto.tfvars`.
By default the monitors are installed in a folder named as `Kubernetes`, if you want to change the folder name, set the variable `folder` in the file `kubernetes.auto.tfvars`.

### Installation Steps

* Make sure that `Terraform 0.13+` is installed.
* Run `terraform init`.
* Configure `Sumo Logic Authentication` details in the file `kubernetes.auto.tfvars` as explained in the previous step.
* Optionally, update the monitor folder name in the file `kubernetes.auto.tfvars`.
* Based on your requirement, enable or disable all the monitors by setting the flag `monitors_disabled` in `kubernetes.auto.tfvars`.
* Configure Email and Connection notifications in the file `kubernetes_notifications.auto.tfvars`.
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
|Metrics|etcd Insufficient Members|etcd cluster insufficient members.|Critical|
|Metrics|Kube API Down|KubeAPI disappeared from Prometheus target discovery.|Critical/MissingData|
|Metrics|Kube Controller Manager Down|KubeControllerManager has disappeared from Prometheus target discovery.|Critical|
|Metrics|Kubelet Down|Kubelet has disappeared from Prometheus target discovery.|Critical/MissingData|
|Metrics|Kube Node Not Ready|Node is not ready.|Critical/MissingData|
|Metrics|Kube Scheduler Down|Kube Scheduler has disappeared from Prometheus target discovery.|Critical/MissingData|
|Metrics|Cluster CPU utilization High|Alerts when Cluster CPU utlization is high.|Critical/Warning|
|Metrics|Prometheus Remote Storage Failures|Prometheus fails to send samples to remote storage.|Critical|
|Metrics|Multiple Terminated pods founds|Alerts when there are pods that have been terminated.|Critical|
|Metrics|Kube Pod Crash Looping|Pod is crash looping.|Warning|
|Metrics|Kube Container Waiting|Pod container waiting longer than 1 hour.|Warning|
|Metrics|Kube DaemonSet Not Scheduled|DaemonSet pods are not scheduled.|Warning|
|Metrics|Kube DaemonSet MisScheduled|DaemonSet pods are miss-scheduled.|Warning|
|Metrics|Kube StatefulSet Generation Mismatch|StatefulSet generation mismatch due to possible roll-back.|Warning|
|Metrics|Kube Hpa Maxed Out|HPA is running at max replicas.|Warning|
|Metrics|Multiple Containers OOM Killed|Multiple Containers are OOM Killed.|Warning|