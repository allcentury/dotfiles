#!/usr/bin/env bash
# Outputs the worktree/task label for the current tmux session.
# Returns empty string (no output) when no worktree is active,
# so the status bar segment is invisible by default.
#
# Usage: worktree.sh <session_name>
# The session name is passed from the tmux status-right format string
# so it's always correct for the session being rendered.

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

session_name="${1:-$(tmux display-message -p '#S' 2>/dev/null)}"
datafile="/tmp/.tmux-worktree-${session_name}"

if [ -f "$datafile" ]; then
  name=$(cat "$datafile" 2>/dev/null)
  if [ -n "$name" ]; then
    icon=$(get_tmux_option "@worktree-icon" "🌿")
    echo "$icon $name"
  fi
fi
