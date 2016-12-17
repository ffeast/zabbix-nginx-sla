# zbx-nginx-sla

Zabbix template for nginx with `nginx-sla` module enabled.

This module collects stats for nginx built with support of the awesome nginx stats collection module [nginx-sla](https://github.com/goldenclone/nginx-sla/blob/master/README.en.md).

It simply dumps stats by calling a dedicated url shipped by `nginx-sla`.

## Capabilities
- This module currently supports a single pool name and no auto-discovery
- 10 collected items
- 6 graphs
- Macros to configure nginx-sla stats location and pool name
- No triggers

## Screenshots
TODO!

## System requirements

- zabbix [zabbix 2.4.7](https://www.zabbix.com/documentation/2.4/manual/introduction/whatsnew247) or later (tested with 2.4.7 only although it should work in newer versions too)
- [nginx](http://nginx.org/) with [nginx-sla](http://nginx.org/) module enabled
- bash
- wget

## Collected items

- number of 2xx, 3xx, 4xx, 5xx and total responses per minute for your `nginx_sla` pool
- 90%, 95%, 99% response time percentile


## Installation

1. Drop `nginx-sla.sh` into your scripts path (it's likely to be somewhat similar to `/etc/zabbix/scripts/`) on your Zabbix agent hosts. Make sure it has +x permissions for zabbix-agent
2. Put `userparameter_nginx_sla.conf` into /etc/zabbix/zabbix_agentd.d/
3. Import `zbx_nginx_sla_template.xml` through zabbix [UI](https://www.zabbix.com/documentation/2.4/manual/web_interface/frontend_sections/configuration/templates?s[]=templates&s[]=export&s[]=import)
4. Configure nginx to support nginx-sla unless it's already done. The detailed reference can be found [here](sdsd). Example configuration:
    ```
    sla_pool main timings=50:100:1000:10000:60000 http=200:404:500:502:503:504 default;
    ```
