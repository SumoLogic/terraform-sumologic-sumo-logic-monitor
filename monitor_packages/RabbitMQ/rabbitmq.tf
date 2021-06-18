module "RabbitMQ-NodeDown" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Node Down"
  monitor_description      = "This alert fires when a node in the RabbitMQ cluster is down."
  monitor_monitor_type     = "Logs"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_system=\"rabbitmq\" messaging_cluster=* \"down\" | json \"log\" as _rawlog nodrop | if(isEmpty(_rawlog),_raw,_rawlog) as _raw | where (_raw contains \"rabbit on node\") | fields messaging_cluster, _raw"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 1,
      time_range       = "5m",
      occurrence_type  = "ResultCount"
      trigger_source   = "AllResults"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 1,
      time_range       = "5m",
      occurrence_type  = "ResultCount"
      trigger_source   = "AllResults"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-HighMemoryUsage" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - High Memory Usage"
  monitor_description      = "This alert fires when memory usage on a node in a RabbitMQ cluster is high."
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_mem_used | avg by messaging_cluster, host"
    B = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_mem_limit  | avg by messaging_cluster, host"
    C = "(#A/#B)*100 along host,messaging_cluster"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 80,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 80,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-HighDiskUsage" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - High Disk Usage"
  monitor_description      = "This alert fires when there is high disk usage on a node in a RabbitMQ cluster."
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_disk_free | eval _value/1024 | avg by messaging_cluster, host"
    B = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_disk_free_limit | avg by messaging_cluster, host"
    C = "100-(#A/#B)*100 along host,messaging_cluster"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 80,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 80,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-TooManyUn-acknowledgedMessages" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Too Many Un-acknowledged Messages"
  monitor_description      = "This alert fires when there are too many un-acknowledged messages on a node in a RabbitMQ cluster."
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_overview_messages_unacked |avg by messaging_cluster, host"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 1000,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 1000,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-NoConsumers" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - No Consumers"
  monitor_description      = "This alert fires when a RabbitMQ queue has no consumers."
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* queue=* metric=rabbitmq_queue_consumers | avg by messaging_cluster, queue"

  }
  triggers = [

    {
      threshold_type   = "LessThan",
      threshold        = 1,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 1,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-Un-routableMessages" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Un-routable Messages"
  monitor_description      = "This alert fires when a node in the RabbitMQ cluster has un-routable messages"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_overview_return_unroutable | avg by messaging_cluster, host"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 1,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 1,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-TooManyConnections" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Too Many Connections"
  monitor_description      = "This alert fires when there are too many connections to a node in a RabbitMQ cluster."
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_overview_connections| avg by messaging_cluster, host"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 1000,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 1000,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
module "RabbitMQ-HighNumberofFileDescriptorsinuse" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - High Number of File Descriptors in use"
  monitor_description      = "This alert fires when the percentage of file descriptors used by a node in a RabbitMQ cluster is high."
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_fd_used | avg by messaging_cluster, host"
    B = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_fd_total | avg by messaging_cluster, host"
    C = "(#A/#B)*100 along host,messaging_cluster"

  }
  triggers = [

    {
      threshold_type   = "GreaterThanOrEqual",
      threshold        = 90,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "Critical",
      detection_method = "StaticCondition"
    },
    {
      threshold_type   = "LessThan",
      threshold        = 90,
      time_range       = "5m",
      occurrence_type  = "Always"
      trigger_source   = "AnyTimeSeries"
      trigger_type     = "ResolvedCritical",
      detection_method = "StaticCondition"
    }
  ]
}
