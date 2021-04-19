# sumologic-postgresql-monitors

This script configures Sumo Logic Monitors for PostgreSQL using Terraform modules.
For installation and configuration, please look at Sumo Logic PostgreSQL [Help Document](https://help.sumologic.com/07Sumo-Logic-Apps/12Databases/PostgreSQL/Install_the_PostgreSQL_app_and_view_the_dashboards).
## License

The Postgresql Terraform script is licensed under the apache v2.0 license.

## Issues

Raise issues at [Issues](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/issues)

## Contributing

* Fork the project on [Github](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor).
* Make your feature addition or fix bug, write tests and commit.
* Create a pull request with one of the maintainer as Reviewer.

### Monitors Created

| Type (Metrics/)|Name|Description|Trigger Type (Critical / Warning / MissingData)|
|---|---|---|---|
Logs|PostgreSQL - Instance Down|This alert fires when the Postgres instance is down|Critical
Metrics |   PostgreSQL - TooManyConnections| This alert fires when we detect that a PostgreSQL instance has too many (90% of allowed) connections) |Critical
Logs|PostgreSQL - SlowQueries| This alert fires when we detect that the PostgreSQL instance is executing slow queries|  Warning
Metrics |   PostgreSQL - Commit Rate Low|  This alert fires when we detect that Postgres seems to be processing very few transactions. |Critical
Logs|PostgreSQL - High Rate of Statement Timeout| This alert fires when we detect Postgres transactions show a high rate of statement timeouts  |Critical
Metrics |   PostgreSQL - High Rate Deadlock| This alert fires when we detect deadlocks in a Postgres instance  |Critical
Metrics |   PostgreSQL - High Replication Delay| This alert fires when we detect that the Postgres Replication Delay  is high. |Critical
Metrics | pg_stat_ssl View  PostgreSQL - SSL Compression| Active This alert fires when we detect database connections with SSL compression are enabled. This may add significant jitter in replication delay. Replicas should turn off SSL compression via `sslcompression=0` in `recovery.conf` |Critical
Metrics |   PostgreSQL - Too Many Locks Acquired|  This alert fires when we detect that there are too many locks acquired on the database. If this alert happens frequently, you may need to increase the postgres setting max_locks_per_transaction.  |Critical
Logs|PostgreSQL - Access from Highly Malicious Sources| This alert will fire when a Postgres instance is accessed from known malicious IP addresses.  |Critical
