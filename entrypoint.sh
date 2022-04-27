#!/bin/bash

set -e

if [ "$1" = 'server' ]; then
  shift
  # Figure out public address
  export GHIDRA_REPOS_DIR=/home/ghidra/repos
  export GHIDRA_PUBLIC_HOSTNAME=${GHIDRA_PUBLIC_HOSTNAME:-$(dig +short myip.opendns.com @resolver1.opendns.com)}

  # Add users
  GHIDRA_USERS=${GHIDRA_USERS:-admin}
  if [ ! -e "$GHIDRA_REPOS_DIR/users" ] && [ ! -z "${GHIDRA_USERS}" ]; then
    mkdir -p $GHIDRA_REPOS_DIR/~admin
    for user in ${GHIDRA_USERS}; do
      echo "Adding user: ${user}"
      echo "-add ${user}" >> $GHIDRA_REPOS_DIR/~admin/adm.cmd
    done
  fi

  exec "/home/ghidra/server/ghidraSvr" console
fi

exec "$@"
