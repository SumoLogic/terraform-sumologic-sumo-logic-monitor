variable "nginx_metric_data_source" {
  type = string
  description = "Nginx Metrics Sumo Logic Data Source. For eg: _sourceCategory=Nginx/Metrics"
}

variable "nginx_logs_data_source" {
  type = string
  description = "Nginx Logs Sumo Logic Data Source. For eg: _sourceCategory=Nginx/Logs"
}

variable "alerts_folder_name" {
  type = string
  description = "Folder name to install the Nginx alerts."
  default = "Nginx"
}

variable "connection_notifications" {
  type        = list(object(
                {
                  connection_type = string,
                  connection_id = string,
                  payload_override = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Connection Notifications to be sent by the alert."
}

variable "email_notifications" {
  type        = list(object(
                {
                  connection_type = string,
                  recipients = list(string),
                  subject = string,
                  time_zone = string,
                  message_body = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Email Notifications to be sent by the alert."
}

variable "group_notifications" {
  type        = bool
  description = "Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true."
  default     = true
}