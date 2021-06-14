module "RabbitMQ-DiskUsage" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Disk Usage"
  monitor_description      = "Percentage of available disk space (storeUsage) used by the broker’s persistent message store. Critical Alert > 80%"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_disk_free | eval _value/1024"
    B = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_disk_free_limit"
    C = "100-(#A/#B)*100 along host | avg by host,messaging_cluster"

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
module "RabbitMQ-BrokerMemory" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Broker Memory"
  monitor_description      = "Percentage of available memory used by the broker. Critical Alert > 80%"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_mem_used"
    B = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_mem_limit "
    C = "(#A/#B)*100 along host,node"

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
module "RabbitMQ-Consumer" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Consumer"
  monitor_description      = "A queue has less than 1 consumer"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_queue_consumers"

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
module "RabbitMQ-TooMuchConnections" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Too Much Connections"
  monitor_description      = "The total connections of a cluster is too high >1000"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_overview_connections| avg by messaging_cluster"

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
module "RabbitMQ-UnAckMessage" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - UnAck Message"
  monitor_description      = "Too much unacknowledged messages: greater than 1000"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_overview_messages_unacked |avg by messaging_cluster "

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
module "RabbitMQ-NodeDown" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Node Down"
  monitor_description      = "Rabbitmq node down  when greater than 1 node down."
  monitor_monitor_type     = "Logs"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_system=\"rabbitmq\" messaging_cluster=* \"down\" | json \"log\" as _rawlog nodrop | if(isEmpty(_rawlog),_raw,_rawlog) as _raw | where (_raw contains \"rabbit on node\")"

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
module "RabbitMQ-FileDescriptorsUsage" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - File Descriptors Usage"
  monitor_description      = "A node use more than 90% of file descriptors"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_fd_used "
    B = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_node_fd_total"
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
module "RabbitMQ-UnroutableMessage" {
  source = "SumoLogic/sumo-logic-monitor/sumologic"
  #version						= "{revision}"
  monitor_name             = "RabbitMQ - Unroutable Message"
  monitor_description      = "A queue has unroutable messages"
  monitor_monitor_type     = "Metrics"
  monitor_parent_id        = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled      = var.monitors_disabled
  group_notifications      = var.group_notifications
  connection_notifications = var.connection_notifications
  email_notifications      = var.email_notifications
  queries = {
    A = "${var.rabbitmq_data_source} messaging_cluster=* host=* metric=rabbitmq_overview_return_unroutable | avg by messaging_cluster"

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
