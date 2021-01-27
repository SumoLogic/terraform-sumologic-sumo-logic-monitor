# Sumo Logic Metrics Monitors Example
module "KubeAPIDown" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeAPIDown"
  monitor_description         = "KubeAPI disappeared from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeControllerManagerDown"
  monitor_description         = "KubeControllerManager has disappeared from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeletDown"
  monitor_description         = "Kubelet has disappeared from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeNodeNotReady"
  monitor_description         = "Node is not ready."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeSchedulerDown"
  monitor_description         = "Kube Scheduler has disappeared from Prometheus target discovery."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "Cluster CPU utilization High"
  monitor_description         = "Alerts when Cluster CPU utlization is high."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}


module "PrometheusRemoteStorageFailures" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "PrometheusRemoteStorageFailures"
  monitor_description         = "Prometheus fails to send samples to remote storage."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=prometheus_remote_storage_failed_samples_total (job=collection-kube-prometheus-prometheus  or job=collection-prometheus-oper-prometheus) | quantize 5m | rate"
    B = "metric=prometheus_remote_storage_succeeded_samples_total (job=collection-kube-prometheus-prometheus  or job=collection-prometheus-oper-prometheus) | quantize 5m | rate"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "MultipleTerminatedPodsFounds" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "Multiple Terminated pods founds"
  monitor_description         = "Alerts when there are pods that have been terminated."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_pod_container_status_terminated_reason !reason=completed | sum"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubePodCrashLooping" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubePodCrashLooping"
  monitor_description         = "Pod is crash looping."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_pod_container_status_restarts_total job=kube-state-metrics | quantize 5m | rate | eval _value * 60 * 5"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeContainerWaiting" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeContainerWaiting"
  monitor_description         = "Pod container waiting longer than 1 hour."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_pod_container_status_waiting_reason job=kube-state-metrics | sum by cluster, namespace, container, pod"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeDaemonSetNotScheduled" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeDaemonSetNotScheduled"
  monitor_description         = "DaemonSet pods are not scheduled."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_daemonset_status_desired_number_scheduled job=kube-state-metrics"
    B = "metric=kube_daemonset_status_current_number_scheduled job=kube-state-metrics"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeDaemonSetMisScheduled" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeDaemonSetMisScheduled"
  monitor_description         = "DaemonSet pods are misscheduled."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_daemonset_status_number_misscheduled job=kube-state-metrics"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeStatefulSetGenerationMismatch" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeStatefulSetGenerationMismatch"
  monitor_description         = "StatefulSet generation mismatch due to possible roll-back."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_statefulset_status_observed_generation job=kube-state-metrics"
    B = "metric=kube_statefulset_metadata_generation job=kube-state-metrics"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "KubeHpaMaxedOut" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "KubeHpaMaxedOut"
  monitor_description         = "HPA is running at max replicas."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=kube_hpa_status_current_replicas job=kube-state-metrics"
    B = "metric=kube_hpa_spec_max_replicas job=kube-state-metrics"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "etcdInsufficientMembers" {
  source                    = "../../"
  #version                  = "{revision}"
  monitor_name                = "etcdInsufficientMembers"
  monitor_description         = "etcd cluster has insufficient members."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=up job=*etcd* | sum by job"
    B = "metric=up job=*etcd* | count by job | eval _value + 1 | eval _value /2"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}