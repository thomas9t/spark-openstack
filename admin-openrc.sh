#!/usr/bin/env bash
#change these based on the OpenStack instance
export OS_PROJECT_ID="f407c255c58b47a8a4b02e947be8a61b"
export OS_PASSWORD="67e07bc119cb"

export OS_AUTH_URL="http://ctl.spark-cluster.orion-pg0.utah.cloudlab.us:5000/v3"


export OS_TENANT_NAME="admin"
export OS_USER_DOMAIN_NAME="default"
export OS_USERNAME="admin"

export OS_REGION_NAME="RegionOne"
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi