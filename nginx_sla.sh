#!/bin/bash

# zabbix requested parameter
ZBX_REQ_DATA="$1"
ZBX_REQ_POOL="$2"
ZBX_REQ_DATA_URL="$3"

# nginx defaults
NGINX_SLA_STATUS_DEFAULT_URL="http://localhost:80/sla_status"
WGET_BIN="/usr/bin/wget"

# error handling:
# - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
# - items need to be of type "float" (allow negative + float)
ERROR_NO_ACCESS_FILE="-0.9900"
ERROR_NO_ACCESS="-0.9901"
ERROR_WRONG_PARAM="-0.9902"
ERROR_DATA="-0.9903" # either can not connect /	bad host / bad port

# handle host and port if non-default
if [ ! -z "$ZBX_REQ_DATA_URL" ]; then
  URL="$ZBX_REQ_DATA_URL"
else
  URL="$NGINX_SLA_STATUS_DEFAULT_URL"
fi

# save the nginx stats in a variable for future parsing
NGINX_STATS=$($WGET_BIN -q $URL -O - 2> /dev/null)

# error during retrieve
if [ $? -ne 0 -o -z "$NGINX_STATS" ]; then
  echo $ERROR_DATA
  exit 1
fi

# extract data from nginx sla stats
# xargs is used to strip spaces
ZBX_ABS_NAME=$ZBX_REQ_POOL.$ZBX_REQ_DATA
case $ZBX_REQ_DATA in
   all.http*|all.time*|all.[0-9]*%)    echo "$NGINX_STATS" | grep -E "$ZBX_ABS_NAME =" | cut -f2 -d"=" | xargs ;;
   *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0
