#!/bin/bash

if [[ ! -e "/home/$RUNUSER/.asdf" ]]; then
  mv /opt/asdf "/home/$RUNUSER/.asdf"
  chown -R "$RUNUSER". "/home/$RUNUSER/.asdf"
fi
