#!/bin/bash

HOME="/home/$RUNUSER"

if [[ ! -e "$HOME/.asdf" ]]; then
  cp -r /root/.asdf "$HOME/.asdf"

  for f in $(find "$HOME/.asdf/shims" -type f); do
    sed -i "s#/root/#$HOME/#g" "$f"
  done

  for f in $(find "$HOME/.asdf/installs" -type f -exec grep -Iq . {} \; -print); do
    sed -i "s#/root/#$HOME/#g" "$f"
  done

  for sym in $(find "$HOME/.asdf" -type l); do
    target="$(readlink $sym)"
    if [[ "$target" = /root/* ]]; then
      rm "$sym"
      ln -s "$HOME/${target#/root/}" "$sym"
    fi
  done

  chown -R "$RUNUSER". "$HOME/.asdf"

  cp /root/.tool-versions "/$HOME/.tool-versions"
  chown "$RUNUSER". "$HOME/.tool-versions"

  echo '. $HOME/.asdf/asdf.sh' >> "$HOME/.zshrc"
  chown "$RUNUSER". "$HOME/.zshrc"
fi
