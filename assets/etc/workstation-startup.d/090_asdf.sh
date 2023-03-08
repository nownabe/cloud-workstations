#!/bin/bash

if [[ ! -e "/home/$RUNUSER/.asdf" ]]; then
  mv /opt/asdf "/home/$RUNUSER/.asdf"
  chown -R asdf. "/home/$RUNUSER/.asdf"
fi
