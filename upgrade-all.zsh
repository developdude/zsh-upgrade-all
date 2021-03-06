#!/bin/sh

upgrade-all() {
  tasks=(
    'brew upgrade && brew cleanup'
    'docker system prune --force --all'
    'for app in $(brew cask outdated); do brew cask reinstall $app; done'
    'softwareupdate -l'
    softwareupdate -i -a
  )

  local session=""
  for task in "${tasks[@]}"; do
    if [[ "$session" = "" ]]; then
      session="upgrades"
      # echo run
      tmux new-session -d -s $session "echo '$task'; time $task"
      tmux select-window -t upgrades:0
      # tmux setw remain-on-exit on
    else
      tmux new-window "echo '$task'; $task"
      # tmux setw remain-on-exit on
    fi
    tmux select-layout
  done

  tmux attach-session -t $session
}
