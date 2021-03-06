#!/usr/bin/env bash

#####################################################################
#
# Post dynamic data to kmx, sleep 3 seconds in every loop.
# Use restful api.
#
#
# author   : lidong9144@163.com
# version  : 0.0.1
#
#####################################################################

url="http://192.168.130.62:8082/data-service/v2/channels/devices/data"

fieldGroupId=shangu_dynamic

deviceIdList="d_lxgfj00002"

fields="t_value standard_time"

while true
do
  for deviceId in $deviceIdList
  do
    fieldBody="{\"fieldValue\": \"$deviceId\", \"fieldId\": \"deviceNo\"},"

    for field in $fields
    do
      value=$RANDOM
      fieldBody=$fieldBody"{\"fieldId\": \"$field\", \"fieldValue\": $value},"
    done

    len=`expr ${#fieldBody} - 1`
    fieldBody=${fieldBody:0:len}

    timestamp=`expr $(date +%s) \* 1000`

    body="{\"fieldGroupId\": \"$fieldGroupId\", \
      \"sampleTime\": {\"timestamp\": $timestamp}, \
      \"fields\": [$fieldBody] \
      }"

    echo "post kmx. url: $url, body: $body"

    curl -d "$body" "$url"
  done

  sleep 3
done 
