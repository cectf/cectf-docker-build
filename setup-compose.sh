#!/bin/bash

source nfs-env.sh

render () {
cat $1.yml.template \
  | sed -r "s!%%nfs_host_ip%%!$CECTF_NFS_HOST_IP!g" \
  | sed -r "s!%%staging_config%%!$CECTF_STAGING_CONFIG!g" \
  | sed -r "s!%%staging_challenge_files%%!$CECTF_STAGING_CHALLENGE_FILES!g" \
  | sed -r "s!%%production_config%%!$CECTF_PRODUCTION_CONFIG!g" \
  | sed -r "s!%%production_challenge_files%%!$CECTF_PRODUCTION_CHALLENGE_FILES!g" \
  > $1.yml
}

render registry-compose
render staging-compose
render production-compose
render loadbalancer-compose
