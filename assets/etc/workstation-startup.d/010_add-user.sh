#!/bin/bash

useradd -m "$RUNUSER" -G docker,sudo --shell /bin/zsh > /dev/null
passwd -d "$RUNUSER" >/dev/null
echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers

