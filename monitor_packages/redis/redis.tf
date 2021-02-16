# Sumo Logic Redis Metric Monitors
module "Redis-HighCPUUsage" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - High CPU Usage"
  monitor_description         = "This alert is fired if user and system cpu usage for a host exceeds 80%."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_used_cpu_sys | quantize 1m | rate | sum by host"
    B = "metric=redis_used_cpu_user | quantize 1m | rate | sum by host"
    C = "#A+#B"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 80,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 80,
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

module "Redis-Instancedown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Instance down"
  monitor_description         = "This alert fires when the Redis instance is down."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_uptime"
  }

  # Triggers
  triggers = [
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "Redis-Master-SlaveIO" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Master-Slave IO"
  monitor_description         = "It has been 60 seconds that the io between master and slave was down."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_master_last_io_seconds_ago"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 60,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 60,
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

module "Redis-MemFragmentationRatioHigherthan" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Mem Fragmentation Ratio Higher than 1.5"
  monitor_description         = "Compares Compares Redis memory usage to Linux virtual memory pages (mapped to physical memory chunks). A high ratio will lead to swapping and performance degradation."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_mem_fragmentation_ratio"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 1.5,
                  time_range = "15m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
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


module "Redis-MissingMaster" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Missing master"
  monitor_description         = "This alert fires when we detect that a Redis cluster has no node marked as master."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_uptime (replication_role=master or role=master) | count"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
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
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "Redis-OutOfMemory" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Out Of Memory"
  monitor_description         = "This alert fires when we detect that a Redis node is running out of memory (> 90%)."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_used_memory"
    B = "metric=redis_total_system_memory"
    C = "(#A/#B)*100"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 90,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 90,
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

module "Redis-RejectedConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Rejected Connections"
  monitor_description         = "This alert fires when we detect that some connections to a Redis cluster has been rejected."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_rejected_connections | quantize 1m | delta"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
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

module "Redis-ReplicaLag" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Replica Lag"
  monitor_description         = "Replica - Lag (sec) greater than 60 sec."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_replication_lag"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 60,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 60,
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

module "Redis-ReplicationBroken" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Replication Broken"
  monitor_description         = "This alert fires when we detect that a Redis instance has lost all slaves."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_connected_slaves | quantize 1m | delta"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "LessThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "GreaterThanOrEqual",
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

module "Redis-ReplicationOffset" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Replication Offset"
  monitor_description         = "Redis Replication Offset is greater than 1 MB for last five minutes."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_replication_offset | eval _value/1000000"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 1,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 1,
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

module "Redis-TooManyConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Redis - Too Many Connections"
  monitor_description         = "This alert fires when we detect a given Redis server has too many connections (over 100)."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "metric=redis_clients | sum by server"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 100,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Warning",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 100,
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