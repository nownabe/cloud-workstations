#!/bin/bash

HOME="/home/$RUNUSER"

asdf_dir=/opt/asdf
user_dir="$HOME/.asdf"

# for shared libraries in the asdf directory
chmod 755 "$asdf_dir"

if [[ ! -e "$HOME/.asdf" ]]; then
  cp -r "$asdf_dir" "$user_dir"

  for f in $(find "$user_dir/shims" -type f); do
    sed -i "s#$asdf_dir#$user_dir#g" "$f"
  done

  for f in $(find "$user_dir/installs" -type f -exec grep -Iq . {} \; -print); do
    sed -i "s#$asdf_dir#$user_dir#g" "$f"
  done

  for sym in $(find "$user_dir" -type l); do
    target="$(readlink $sym)"
    if [[ "$target" = $asdf_dir/* ]]; then
      rm "$sym"
      ln -s "$user_dir/${target#$asdf_dir}" "$sym"
    fi
  done

  chown -R "$RUNUSER". "$user_dir"

  cp /root/.tool-versions "$HOME/.tool-versions"
  chown "$RUNUSER". "$HOME/.tool-versions"

  echo '. $HOME/.asdf/asdf.sh' >> "$HOME/.zshrc"
  chown "$RUNUSER". "$HOME/.zshrc"
fi
