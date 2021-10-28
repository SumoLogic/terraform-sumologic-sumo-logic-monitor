# sumologic-telegegraf-http_response monitors

This Terraform script configures pre-packaged Sumo Logic Monitors for use with the telegraf [http_response plugin](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/http_response) using Terraform modules.

For an example implmentation see:  [this example](https://github.com/rjury-sumo/sumo-telegraf-agent).

Alerts created:
- http_response - Failed HTTP 4XX Code
- http_response - Failed HTTP 5XX Code
- http_response - Failed HTTP Check
- http_response - High Page Response Time

## License

This Terraform script is licensed under the apache v2.0 license.
Telegraf license see: https://github.com/influxdata/telegraf/blob/master/LICENSE

## Issues

Raise issues at [Issues](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor/issues)

## Contributing

* Fork the project on [Github](https://github.com/SumoLogic/terraform-sumologic-sumo-logic-monitor).
* Make your feature addition or fix bug, write tests and commit.
* Create a pull request with one of the maintainer as Reviewer.