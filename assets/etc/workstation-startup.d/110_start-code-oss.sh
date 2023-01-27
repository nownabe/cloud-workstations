#!/bin/bash

echo "Starting Code OSS"

export PATH=$PATH:/usr/local/go/bin
export HOME="/home/$RUNUSER"
export EDITOR_PORT=80

function start_code_oss {
  runuser "$RUNUSER" -c -l "cd /opt/code-oss && ./bin/codeoss-cloudworkstations --port=${EDITOR_PORT} --host=0.0.0.0"
}

function kill_container {
  echo "Code OSS exited, terminating container."
  ps x | awk {'{print $1}'} | awk 'NR > 1' | xargs kill
}

(start_code_oss || kill_container)&

