#!/bin/bash


# Create a group for the docker socket if one does not exist
# and then add this group to the gitlab runner
DOCKER_ID=`ls -ln /var/run/docker.sock | awk '{ print $4 }'`

GROUP_NAME=`grep ":$DOCKER_ID:" /etc/group | sed 's|:.*||' 2>/dev/null`
if [ -z "$GROUP_NAME" ]; then
  GROUP_NAME=docker
  groupadd -g $DOCKER_ID $GROUP_NAME
fi

usermod -a -G $GROUP_NAME gitlab-runner 

exec /usr/bin/gitlab-runner "$@"
