#!/usr/bin/env bash
# tmux-worktree: displays the current worktree/task name in the tmux status bar.
#
# Uses a tmux session option (@worktree-name) for instant rendering —
# no shell script, no file I/O, no status-interval dependency.
#
# Set the worktree name on a session:
#   tmux set-option -t <session> @worktree-name "my-feature"
#
# Clear it:
#   tmux set-option -t <session> -u @worktree-name
#
# Options:
#   @worktree-colors "fg bg"   (default: "#282a36 #50fa7b" — dark on green, Dracula palette)
#   @worktree-icon "🌿"        (default: 🌿)

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

main() {
  local fg bg icon current_status worktree_segment
  IFS=' ' read -r fg bg <<< "$(get_tmux_option "@worktree-colors" "#282a36 #50fa7b")"
  icon=$(get_tmux_option "@worktree-icon" "🌿")

  # #{?@worktree-name,...,} is a tmux conditional format:
  # if @worktree-name is set on the session, render the segment; otherwise render nothing.
  worktree_segment="#{?@worktree-name,#[fg=${fg}#,bg=${bg}] ${icon} #{@worktree-name} ,}"
  current_status=$(tmux show-option -gqv status-right)

  # Prepend so the worktree label appears first (leftmost) in status-right
  tmux set-option -g status-right "${worktree_segment}${current_status}"
}

main
