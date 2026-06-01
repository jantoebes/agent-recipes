#!/bin/bash
LOCAL_PORT=$1
REMOTE_HOST=$2
CONN=$3

if ! lsof -i :$LOCAL_PORT -sTCP:LISTEN > /dev/null 2>&1; then
  ssh -f -N -L $LOCAL_PORT:$REMOTE_HOST:5432 jtoebes@vm-bastion-opc.intra.dhlparcel.io
fi

npx -y @modelcontextprotocol/server-postgres "$CONN"
