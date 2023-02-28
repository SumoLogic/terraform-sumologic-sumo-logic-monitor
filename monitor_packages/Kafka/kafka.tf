# Sumo Logic Kafka Metric Monitors
module "HighBrokerDiskUtilization" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - High Broker Disk Utilization"
  monitor_description         = "This alert fires when we detect that a disk on a broker node is more than 85% full."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source}  host=* metric=*disk_used_percent | avg by messaging_cluster, host"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 85,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 85,
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

module "FailedZookeeperconnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Failed Zookeeper connections"
  monitor_description         = "This alert fires when we detect Broker to Zookeeper connection failures."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=kafka_zookeeper_auth_failures_Count jolokia_agent_url=* | parse field=jolokia_agent_url * as Server"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
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

module "HighLeaderElectionRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - High Leader election rate"
  monitor_description         = "This alert fires when we detect high leader election rate."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=kafka_controller_LeaderElectionRateAndTimeMs_MeanRate jolokia_agent_url=* | parse field=jolokia_agent_url * as Server"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
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

module "GarbageCollection" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Garbage collection"
  monitor_description         = "This alert fires when we detect that the average Garbage Collection time on a given Kafka broker node over a 5 minute interval is more than one second."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=*java_lang_GarbageCollector_LastGcInfo_duration jolokia_agent_url =* | avg by messaging_cluster, host"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 1000,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 1000,
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

module "OfflinePartitions" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Offline Partitions"
  monitor_description         = "This alert fires when we detect offline partitions on a given Kafka broker."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=kafka_controller_OfflinePartitionsCount_Value jolokia_agent_url=* | parse field=jolokia_agent_url * as Server"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "AtLeastOnce" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
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

module "FatalEventonBroker" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Fatal Event on Broker"
  monitor_description         = "This alert fires when we detect a fatal operation on a Kafka broker node"
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "\nmessaging_system=kafka ${var.kafka_data_source} \n| json auto maxdepth 1 nodrop\n| if (isEmpty(log), _raw, log) as kafka_log_message\n| parse field=kafka_log_message \"[*] * *\" as date_time,severity,msg\n| where severity =\"FATAL\""
  }

  # Triggers
  triggers = [
              {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThan",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults" 
          
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThanOrEqual",
                  occurrence_type = "ResultCount"
                  trigger_source = "AllResults" 
                  
                  
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "UnderreplicatedPartitions" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Underreplicated Partitions"
  monitor_description         = "This alert fires when we detect underreplicated partitions on a given Kafka broker."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source}  metric=kafka_partition_UnderReplicatedPartitions  jolokia_agent_url=* | parse field=jolokia_agent_url * as Server | sum by Server,messaging_cluster"
  }

  # Triggers
  triggers = [
              {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThanOrEqual",
                  occurrence_type = "AtLeastOnce",
                  trigger_source = "AnyTimeSeries" 
          
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThan",
                  occurrence_type = "Always"
                  trigger_source = "AnyTimeSeries" 
                  
                  
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "BrokerErrors" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Large number of broker errors"
  monitor_description         = "This alert fires when we detect that there are 5 or more errors on a Broker node within a time interval of 5 minutes."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.kafka_data_source} messaging_system=kafka\n| json auto maxdepth 1 nodrop\n| if (isEmpty(log), _raw, log) as kafka_log_message\n| parse field=kafka_log_message \"[*] * *\" as date_time,severity,msg\n| where severity in (\"ERROR\")"
  }

  # Triggers
  triggers = [
              {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 5,
                  threshold_type = "GreaterThanOrEqual",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults" 
          
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 5,
                  threshold_type = "LessThan",
                  occurrence_type = "ResultCount"
                  trigger_source = "AllResults" 
                  
                  
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "HighCPUBrokerNode" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - High CPU on Broker node"
  monitor_description         = "This alert fires when we detect that the average CPU utilization for a broker node is high (>=85%) for an interval of 5 minutes."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=*java_lang_OperatingSystem_SystemCpuLoad jolokia_agent_url=* | eval(_value*100) | avg by messaging_cluster, jolokia_agent_url"
  }

  # Triggers
  triggers = [
              {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 85,
                  threshold_type = "GreaterThanOrEqual",
                  occurrence_type = "Always",
                  trigger_source = "AnyTimeSeries" 
          
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 85,
                  threshold_type = "LessThan",
                  occurrence_type = "Always"
                  trigger_source = "AnyTimeSeries" 
                  
                  
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "OutOfSyncFollowers" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - Out of Sync Followers"
  monitor_description         = "This alert fires when we detect that there are Out of Sync Followers within a time interval of 5 minutes."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=kafka_replica_manager_UnderMinIsrPartitionCount_Value jolokia_agent_url=*| parse field=jolokia_agent_url * as Server"
  }

  # Triggers
  triggers = [
              {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThanOrEqual",
                  occurrence_type = "Always",
                  trigger_source = "AnyTimeSeries" 
          
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThan",
                  occurrence_type = "Always"
                  trigger_source = "AnyTimeSeries" 
                  
                  
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "HighBrokerMemUtilization" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Kafka - High Broker Memory Utilization"
  monitor_description         = "This alert fires when the average memory utilization within a 5 minute interval for a given Kafka node is high (>=85%)."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "messaging_system=kafka ${var.kafka_data_source} metric=**java_lang_OperatingSystem_FreePhysicalMemorySize jolokia_agent_url=* | avg by messaging_cluster, jolokia_agent_url\n"
    B = "messaging_system=kafka ${var.kafka_data_source} metric=**java_lang_OperatingSystem_TotalPhysicalMemorySize jolokia_agent_url=* | avg by messaging_cluster, jolokia_agent_url\n"
    C = "(1 - (#A / #B)) * 100"
  }

  # Triggers
  triggers = [
              {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 85,
                  threshold_type = "GreaterThanOrEqual",
                  occurrence_type = "Always",
                  trigger_source = "AnyTimeSeries" 
          
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 85,
                  threshold_type = "LessThan",
                  occurrence_type = "Always"
                  trigger_source = "AnyTimeSeries" 
                  
                  
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}