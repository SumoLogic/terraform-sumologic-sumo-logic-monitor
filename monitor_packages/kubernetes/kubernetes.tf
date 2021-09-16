# Sumo Logic Kubernetes Metric Monitors
module "KubeAPIDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Kube API Down"
  monitor_description         = "This alert is fired when KubeAPI disappears from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=up job=apiserver | sum by cluster,instance,service"
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
                  threshold_type = "",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "",
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
  connection_notifications  = concat(var.connection_notifications_critical, var.connection_notifications_missingdata)
  email_notifications       = concat(var.email_notifications_critical,var.email_notifications_missingdata)
}

module "KubeControllerManagerDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Kube Controller Manager Down"
  monitor_description         = "This alert is fired when KubeControllerManager disappears from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=up job=kube-controller-manager | sum by cluster,instance,service"
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
                  threshold_type = "",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "",
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
  connection_notifications  = concat(var.connection_notifications_critical, var.connection_notifications_missingdata)
  email_notifications       = concat(var.email_notifications_critical,var.email_notifications_missingdata)
}

module "KubeletDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Kubelet Down"
  monitor_description         = "This alert is fired when Kubelet disappears from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=up job=kubelet metrics_path=/metrics | sum by cluster,instance,service"
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
                  threshold_type = "",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "",
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
  connection_notifications  = concat(var.connection_notifications_critical, var.connection_notifications_missingdata)
  email_notifications       = concat(var.email_notifications_critical,var.email_notifications_missingdata)
}

module "KubeNodeNotReady" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Kube Node Not Ready"
  monitor_description         = "This alert is fired when a node is not ready."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_node_status_condition job=kube-state-metrics condition=ready status=true | sum by cluster,node"
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
                  threshold_type = "",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "",
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
  connection_notifications  = concat(var.connection_notifications_critical, var.connection_notifications_missingdata)
  email_notifications       = concat(var.email_notifications_critical,var.email_notifications_missingdata)
}

module "KubeSchedulerDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Kube Scheduler Down"
  monitor_description         = "This alert is fired when Kube Scheduler disappears from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=up job=scheduler | sum by cluster,instance,service"
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
                  threshold_type = "",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "MissingData" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "MissingData",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "",
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
  connection_notifications  = concat(var.connection_notifications_critical, var.connection_notifications_missingdata)
  email_notifications       = concat(var.email_notifications_critical,var.email_notifications_missingdata)
}


module "NodeCPUUtilizationHigh" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Node CPU Utilization High"
  monitor_description         = "This alert is fired when Node CPU utlization is high."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=node:node_cpu_utilisation:avg1m | sum by cluster,node"
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
                  threshold_type = "LessThanOrEqual",
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
                  threshold_type = "LessThanOrEqual",
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
  connection_notifications  = concat(var.connection_notifications_critical, var.connection_notifications_warning)
  email_notifications       = concat(var.email_notifications_critical,var.email_notifications_warning)
}

module "PrometheusRemoteStorageFailures" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Prometheus Remote Storage Failures"
  monitor_description         = "This alert is fired when Prometheus fails to send samples to remote storage."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=prometheus_remote_storage_failed_samples_total (job=collection-kube-prometheus-prometheus  or job=collection-prometheus-oper-prometheus) | quantize 5m | rate"
    B = "${var.kubernetes_data_source} metric=prometheus_remote_storage_succeeded_samples_total (job=collection-kube-prometheus-prometheus  or job=collection-prometheus-oper-prometheus) | quantize 5m | rate"
    C = "100*(#A/(#A+#B)) along namespace,pod"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 1,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 1,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
}

module "MultipleTerminatedPodsErroredOut" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Multiple Terminated Pods (Errored Out)"
  monitor_description         = "This alert is fired when we determine that there are pods that have been terminated because of errors."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_terminated_reason reason=error | sum by cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
}

module "MultipleTerminatedPodsContainerCannotRun" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Multiple Terminated Pods (Container Cannot Run)"
  monitor_description         = "This alert is fired when we determine that there are pods that have been terminated as the container cannot run."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_terminated_reason reason=containercannotrun | sum by cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
}

module "MultipleTerminatedPodsOOMKilled" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Multiple Terminated Pods (OOM Killed)"
  monitor_description         = "This alert is fired when we determine that there are pods that have been OOM Killed."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_terminated_reason reason=oomkilled | sum by cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
}

module "MultipleTerminatedPodsDeadlineexceeded" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Multiple Terminated Pods (Deadline Exceeded)"
  monitor_description         = "This alert is fired when we determine that there are pods that have been terminated."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_terminated_reason reason=deadlineexceeded | sum by cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
}

module "KubePodCrashLooping" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Pod Crash Looping"
  monitor_description         = "This alert is fired when we determine that a pod is crash looping."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_restarts_total job=kube-state-metrics | quantize 5m | rate | eval _value * 60 * 5"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}

module "KubeContainerWaiting" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Container Waiting"
  monitor_description         = "This alert is fired when a pod container waiting longer than 1 hour."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_waiting_reason job=kube-state-metrics | sum by cluster, namespace, container, pod"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}

module "KubeDaemonSetNotScheduled" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - DaemonSet Not Scheduled"
  monitor_description         = "This alert is fired when DaemonSet pods are not scheduled."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_daemonset_status_desired_number_scheduled job=kube-state-metrics"
    B = "${var.kubernetes_data_source} metric=kube_daemonset_status_current_number_scheduled job=kube-state-metrics"
    C = "#A - #B along daemonset, cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}

module "KubeDaemonSetMisScheduled" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - DaemonSet Misscheduled"
  monitor_description         = "This alert is fired when DaemonSet pods are miss-scheduled."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_daemonset_status_number_misscheduled job=kube-state-metrics | sum by cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}

module "KubeStatefulSetGenerationMismatch" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - StatefulSet Generation Mismatch"
  monitor_description         = "This alert is fired when StatefulSet generation mismatch is determined due to possible roll-back."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_statefulset_status_observed_generation job=kube-state-metrics"
    B = "${var.kubernetes_data_source} metric=kube_statefulset_metadata_generation job=kube-state-metrics"
    C = "#B - #A along statefulset, cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}

module "KubeHpaMaxedOut" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - HPA Maxed Out"
  monitor_description         = "This alert is fired when HPA is running at maximum replicas."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_hpa_status_current_replicas job=kube-state-metrics"
    B = "${var.kubernetes_data_source} metric=kube_hpa_spec_max_replicas job=kube-state-metrics"
    C = "#B - #A along cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}

module "etcdInsufficientMembers" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - etcd Insufficient Members"
  monitor_description         = "This alert is fired when we determine that etcd cluster has insufficient members."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=up job=*etcd* | sum by job"
    B = "${var.kubernetes_data_source} metric=up job=*etcd* | count by job | eval _value + 1 | eval _value /2"
    C = "#B - #A along cluster"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
}


module "MultipleContainersOOMKilled" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kubernetes - Multiple Containers OOM Killed"
  monitor_description         = "This alert is fired when multiple containers are OOM Killed."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kubernetes_data_source} metric=kube_pod_container_status_restarts_total | quantize to 12m | rate increasing | max by namespace, container, pod"
    B = "${var.kubernetes_data_source} metric=kube_pod_container_status_last_terminated_reason reason=\"OOMKilled\" | max by namespace, container, pod | filter max =1"
    C = "#A + #B "
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 5,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 5,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedWarning",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
}
