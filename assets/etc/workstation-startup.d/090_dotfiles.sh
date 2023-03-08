#!/bin/bash

# Personalize Cloud Workstations in the same way as GitHub Codespaces
# https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles

set -o pipefail
set -o errexit

export HOME="/home/$RUNUSER"

[[ -z "$DOTFILES" ]] && exit

config_dir="$HOME/.config/workstations"
done_file="$config_dir/done-dotfiles"
dotfiles_root="$config_dir/dotfiles"

[[ -e "$done_file" ]] && exit

if [[ ! -e "$dotfiles_root" ]]; then
  runuser "$RUNUSER" -l -c "git clone $DOTFILES $dotfiles_root --depth 1"
fi

scripts=(
  "install.sh"
  "install"
  "bootstrap.sh"
  "bootstrap"
  "script/bootstrap"
  "setup.sh"
  "setup"
  "script/setup"
)

for script in ${scripts[@]}; do
  if [[ -e "$dotfiles_root/$script" ]]; then
    if runuser "$RUNUSER" -l -c "$dotfiles_root/$script"; then
      runuser "$RUNUSER" -l -c "touch $done_file"
      exit
    else
      echo "failed to run $script"
      exit 1
    fi
  fi
done


# If setup scripts aren't find, this will make dotfile symlinks.

basedir="$(cd "$(dirname "$0")" && pwd)"

find "$basedir" -name ".*" | while read -r src; do
  name="$(basename "$src")"

  [[ "$name" = ".git" ]] && continue
  [[ "$name" = ".gitignore" ]] && continue

  dst="$HOME/$name"
  echo -n "$name : "

  if [[ -L "$dst" ]]; then
    echo "already exists 😘"
  else
    [[ -e "$dst" ]] && mv "$dst" "$dst.badkup"
    runuser "$RUNUSER" -l -c "ln -s $src $dst"
    echo "created new symbolic link! 🥳"
  fi
done

runuser "$RUNUSER" -l -c "touch $done_file"
