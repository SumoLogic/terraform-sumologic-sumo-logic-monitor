variable "access_id" {
  type = string
  description = "Sumo Logic Access ID. Visit https://help.sumologic.com/Manage/Security/Access-Keys#Create_an_access_key"
  validation {
    condition = length(var.access_id) > 0
    error_message = "The \"sumo_access_id\" can not be empty."
  }
}

variable "access_key" {
  type = string
  description = "Sumo Logic Access Key."
  validation {
    condition = length(var.access_key) > 0
    error_message = "The \"sumo_access_key\" can not be empty."
  }
}

variable "environment" {
  type = string
  description = "Please update with your deployment, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security"
  validation {
    condition = contains([
      "au",
      "ca",
      "de",
      "eu",
      "fed",
      "in",
      "jp",
      "kr",
      "us1",
      "us2"
    ], var.environment)
    error_message = "The value must be one of au, ca, de, eu, fed, in, jp, kr, us1 or us2."
  }
}

variable "folder" {
  type = string
  description = "Folder where monitors will be created."
  default = "Nginx Plus"
}

variable "monitors_disabled" {
  type = bool
  description = "Whether the monitors are enabled or not?"
  default = true
}

variable "metric_data_source" {
  type = string
  description = "Sumo Logic Metrics Data Source. For eg: _sourceCategory=Nginx/Plus/Metrics"
}

variable "logs_data_source" {
  type = string
  description = "Sumo Logic Logs Data Source. For eg: _sourceCategory=Nginx/Plus/Logs"
}

variable "connection_notifications" {
  type = list(object(
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
  type = list(object(
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
  type = bool
  description = "Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true."
  default = true
}