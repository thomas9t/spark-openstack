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


#export OS_AUTH_URL="http://ctl.spark-cluster.orion-pg0.utah.cloudlab.us:5000/v3"
#export OS_USER_DOMAIN_NAME="default"
#export OS_USERNAME="admin"
#export OS_PASSWORD="67e07bc119cb"
#export OS_PROJECT_ID=f"407c255c58b47a8a4b02e947be8a61b"
#
#
#ctl.spark-cluster.orion-pg0.utah.cloudlab.us
#
#./spark-openstack -k temp-key -i ~/temp-key.pem -s 2 -t m1.xlarge -a f79b5f69-e034-46f8-bc84-2ee3ac17d7e6 -n 5cadd2d4-1a31-4171-bc68-08ced4114174 -f 20aa1c2c-c276-45ab-8b53-b924b1ed707b launch test
#
#subprocess.check_output(["ssh", "-q", "-t", "-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/temp-key.pem", "ubuntu@" + "10.11.10.40", "ssh test-slave-1 'echo 1'"], shell=True, stderr=subprocess.STDOUT)
#
#subprocess.check_output(' '.join(["ssh", "-i", "~/temp-key.pem", "ubuntu@" + "10.11.10.40", "ssh test-slave-1 'echo 1'"]), shell=True, stderr=subprocess.STDOUT)