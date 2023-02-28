## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_sumologic"></a> [sumologic](#requirement\_sumologic) | ~> 2.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_sumologic"></a> [sumologic](#provider\_sumologic) | ~> 2.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ActiveMQ-HighCPUUsage"></a> [ActiveMQ-HighCPUUsage](#module\_ActiveMQ-HighCPUUsage) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-HighHostDiskUsage"></a> [ActiveMQ-HighHostDiskUsage](#module\_ActiveMQ-HighHostDiskUsage) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-HighMemoryUsage"></a> [ActiveMQ-HighMemoryUsage](#module\_ActiveMQ-HighMemoryUsage) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-HighNumberofFileDescriptorsinuse"></a> [ActiveMQ-HighNumberofFileDescriptorsinuse](#module\_ActiveMQ-HighNumberofFileDescriptorsinuse) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-HighStorageUsed"></a> [ActiveMQ-HighStorageUsed](#module\_ActiveMQ-HighStorageUsed) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-HighTempUsage"></a> [ActiveMQ-HighTempUsage](#module\_ActiveMQ-HighTempUsage) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-MaximumConnection"></a> [ActiveMQ-MaximumConnection](#module\_ActiveMQ-MaximumConnection) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-NoConsumersonQueues"></a> [ActiveMQ-NoConsumersonQueues](#module\_ActiveMQ-NoConsumersonQueues) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-NoConsumersonTopics"></a> [ActiveMQ-NoConsumersonTopics](#module\_ActiveMQ-NoConsumersonTopics) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-NodeDown"></a> [ActiveMQ-NodeDown](#module\_ActiveMQ-NodeDown) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-TooManyConnections"></a> [ActiveMQ-TooManyConnections](#module\_ActiveMQ-TooManyConnections) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-TooManyExpiredMessagesonQueues"></a> [ActiveMQ-TooManyExpiredMessagesonQueues](#module\_ActiveMQ-TooManyExpiredMessagesonQueues) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-TooManyExpiredMessagesonTopics"></a> [ActiveMQ-TooManyExpiredMessagesonTopics](#module\_ActiveMQ-TooManyExpiredMessagesonTopics) | SumoLogic/sumo-logic-monitor/sumologic | n/a |
| <a name="module_ActiveMQ-TooManyUnacknowledgedMessages"></a> [ActiveMQ-TooManyUnacknowledgedMessages](#module\_ActiveMQ-TooManyUnacknowledgedMessages) | SumoLogic/sumo-logic-monitor/sumologic | n/a |

## Resources

| Name | Type |
|------|------|
| [sumologic_monitor_folder.tf_monitor_folder](https://registry.terraform.io/providers/SumoLogic/sumologic/latest/docs/resources/monitor_folder) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_id"></a> [access\_id](#input\_access\_id) | Sumo Logic Access ID. Visit https://help.sumologic.com/Manage/Security/Access-Keys#Create_an_access_key | `string` | n/a | yes |
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Sumo Logic Access Key. | `string` | n/a | yes |
| <a name="input_activemq_data_source"></a> [activemq\_data\_source](#input\_activemq\_data\_source) | Sumo Logic ActiveMQ Cluster Filter. For eg: messaging\_cluster=activemq.prod.01 | `string` | n/a | yes |
| <a name="input_connection_notifications"></a> [connection\_notifications](#input\_connection\_notifications) | Connection Notifications to be sent by the alert. | <pre>list(object(<br>                {<br>                  connection_type = string,<br>                  connection_id = string,<br>                  payload_override = string,<br>                  run_for_trigger_types = list(string)<br>                }<br>    ))</pre> | n/a | yes |
| <a name="input_email_notifications"></a> [email\_notifications](#input\_email\_notifications) | Email Notifications to be sent by the alert. | <pre>list(object(<br>                {<br>                  connection_type = string,<br>                  recipients = list(string),<br>                  subject = string,<br>                  time_zone = string,<br>                  message_body = string,<br>                  run_for_trigger_types = list(string)<br>                }<br>    ))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Please update with your deployment, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security | `string` | n/a | yes |
| <a name="input_folder"></a> [folder](#input\_folder) | Folder where monitors will be created. | `string` | `"ActiveMQ"` | no |
| <a name="input_group_notifications"></a> [group\_notifications](#input\_group\_notifications) | Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true. | `bool` | `true` | no |
| <a name="input_monitors_disabled"></a> [monitors\_disabled](#input\_monitors\_disabled) | Whether the monitors are enabled or not? | `bool` | `true` | no |
| <a name="input_sumologic_organization_id"></a> [sumologic\_organization\_id](#input\_sumologic\_organization\_id) | You can find your org on the Preferences page in the Sumo Logic UI. For more information, see the Preferences Page topic. For more details, visit https://help.sumologic.com/01Start-Here/05Customize-Your-Sumo-Logic-Experience/Preferences-Page | `string` | n/a | yes |

## Outputs

No outputs.
