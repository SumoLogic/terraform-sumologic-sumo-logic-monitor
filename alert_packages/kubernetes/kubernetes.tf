# Sumo Logic Metrics Alerts Example
module "KubeAPIDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  alert_name                = "KubeAPIDown"
  alert_description         = "KubeAPI disappeared from Prometheus target discovery."
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=up job=apiserver"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData"
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedMissingData",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeControllerManagerDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  alert_name                = "KubeControllerManagerDown"
  alert_description         = "KubeControllerManager has disappeared from Prometheus target discovery."
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=up job=kube-controller-manager"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData"
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedMissingData",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeletDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  alert_name                = "KubeletDown"
  alert_description         = "Kubelet has disappeared from Prometheus target discovery."
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=up job=kubelet metrics_path=/metrics"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData"
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedMissingData",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeNodeNotReady" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  alert_name                = "KubeNodeNotReady"
  alert_description         = "Node is not ready."
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_node_status_condition job=kube-state-metrics condition=ready status=true"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "MissingData"
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedMissingData",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeSchedulerDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  alert_name                = "KubeSchedulerDown"
  alert_description         = "Kube Scheduler has disappeared from Prometheus target discovery."
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=up job=scheduler"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData"
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedMissingData",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}


module "ClusterCPUUtilizationHigh" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  alert_name                = "Cluster CPU utilization High"
  alert_description         = "Alert when Cluster CPU utlization is high."
  alert_monitor_type        = "Metrics"
  alert_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=node:node_cpu_utilisation:avg1m"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0.90,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 0.90,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0.75,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 0.75,
                  time_range = "5m",
                  occurrence_type = "Always"
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}