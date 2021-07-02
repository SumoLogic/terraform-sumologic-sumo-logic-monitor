module "ActiveMQ-MaximumConnection" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - Maximum Connection"
  monitor_description			= "This alert fires when one node in ActiveMQ cluster exceeds the maximum allowed client connection"
  monitor_monitor_type			= "Logs"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_system=\"activemq\" messaging_cluster=* \"Exceeded the maximum number of allowed client connections\"  | json \"log\" as _rawlog nodrop | if(isEmpty(_rawlog),_raw,_rawlog) as _raw |if(isEmpty(pod),_sourcehost,pod) as host  | fields messaging_cluster,host,_raw"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-TooManyConnections" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - Too Many Connections"
  monitor_description			= "This alert fires when there are too many connections to a node in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_broker_CurrentConnectionsCount\"  | avg by host,messaging_cluster "

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-TooManyExpiredMessagesonTopics" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - Too Many Expired Messages on Topics"
  monitor_description			= "This alert fires when there are too many expired messages on a topic in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* destinationName=* metric=\"activemq_topic_ExpiredCount\"| parse  field=destinationName * as topic | avg by topic,messaging_cluster"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-NoConsumersonQueues" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - No Consumers on Queues"
  monitor_description			= "This alert fires when a ActiveMQ queue has no consumers."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* destinationName=* metric=\"activemq_queue_ConsumerCount\" | parse  field=destinationName * as queue |avg by messaging_cluster,queue"

}
  triggers = [

			  {
				threshold_type = "LessThan",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-HighMemoryUsage" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - High Memory Usage"
  monitor_description			= "This alert fires when memory usage on a node in a ActiveMQ cluster is high."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_OperatingSystem_FreePhysicalMemorySize\" "
    B = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_OperatingSystem_TotalPhysicalMemorySize\""
    C = "100-(#A/#B)*100 along host,messaging_cluster | avg by messaging_cluster,host"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-HighTempUsage" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - High Temp  Usage"
  monitor_description			= "This alert fires when there is high temp usage on a node in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_broker_TempPercentUsage\" | avg by messaging_cluster,host"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-HighCPUUsage" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - High CPU Usage"
  monitor_description			= "This alert fires when CPU usage on a node in a ActiveMQ cluster is high."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_OperatingSystem_SystemCpuLoad\" | avg by host,messaging_cluster | eval _value*100"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-HighStoreUsage" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - High Store  Usage"
  monitor_description			= "This alert fires when there is high store usage on a node in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_broker_StorePercentUsage\" | avg by messaging_cluster,host"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-HighHostDiskUsage" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - High Host Disk Usage"
  monitor_description			= "This alert fires when there is high disk usage on a node in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_system=\"activemq\" messaging_cluster=* host=* metric=\"disk_used_percent\" | avg by messaging_cluster,host"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-NoConsumersonTopics" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - No Consumers on Topics"
  monitor_description			= "This alert fires when a ActiveMQ topic has no consumers."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* destinationName=* metric=\"activemq_topic_ConsumerCount\" | parse  field=destinationName * as topic |avg by messaging_cluster,topic"

}
  triggers = [

			  {
				threshold_type = "LessThan",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-HighNumberofFileDescriptorsinuse" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - High Number of File Descriptors in use"
  monitor_description			= "This alert fires when the percentage of file descriptors used by a node in a ActiveMQ cluster is high."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_OperatingSystem_OpenFileDescriptorCount\" "
    B = "${var.activemq_data_source} messaging_cluster=* host=* metric=\"activemq_OperatingSystem_MaxFileDescriptorCount\" "
    C = "(#A/#B) along host,messaging_cluster | avg by messaging_cluster,host"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-NodeDown" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - Node Down"
  monitor_description			= "This alert fires when a node in the ActiveMQ cluster is down."
  monitor_monitor_type			= "Logs"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_system=\"activemq\" messaging_cluster=* \"shutdown\" \"Apache ActiveMQ\" | json \"log\" as _rawlog nodrop | if(isEmpty(_rawlog),_raw,_rawlog) as _raw | fields messaging_cluster,_raw"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-TooManyUn-acknowledgedMessages" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - Too Many Un-acknowledged Messages"
  monitor_description			= "This alert fires when there are too many un-acknowledged messages on a node in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* host=* metric=activemq_*_QueueSize|avg by messaging_cluster,host"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ActiveMQ-TooManyExpiredMessagesonQueues" {
  source						= "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name					= "ActiveMQ - Too Many Expired Messages on Queues"
  monitor_description			= "This alert fires when there are too many expired messages on a queue in a ActiveMQ cluster."
  monitor_monitor_type			= "Metrics"
  monitor_parent_id				= sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled			= var.monitors_disabled
  group_notifications			= var.group_notifications
  connection_notifications		= var.connection_notifications
  email_notifications			= var.email_notifications
  queries = {
    A = "${var.activemq_data_source} messaging_cluster=* destinationName=* metric=\"activemq_queue_ExpiredCount\"| parse  field=destinationName * as queue | avg by messaging_cluster,queue"

}
  triggers = [

			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 1000,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
