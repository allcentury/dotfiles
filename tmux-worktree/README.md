# tmux-worktree

A tmux plugin that displays the active git worktree/task name in your status bar. Designed for workflows where each tmux session maps to a git worktree (e.g., via tmuxinator).

## Install

With [TPM](https://github.com/tmux-plugins/tpm):

```bash
set -g @plugin 'aross/tmux-worktree'
```

Then `prefix + I` to install.

## How it works

The plugin watches for a marker file at `/tmp/.tmux-worktree-<session_name>`. When present, it displays the contents (your task/worktree name) in the status bar. When absent, the segment is invisible.

### Writing the marker

Your session bootstrapper (tmuxinator, etc.) writes the file on start:

```yaml
# .tmuxinator.yml
on_project_start:
  - echo "fix-deposits" > /tmp/.tmux-worktree-Brex-fix-deposits

on_project_exit:
  - rm -f /tmp/.tmux-worktree-Brex-fix-deposits
```

## Options

| Option | Default | Description |
|---|---|---|
| `@worktree-colors` | `"#282a36 #50fa7b"` | `"fg bg"` — foreground and background colors |
| `@worktree-icon` | `🌿` | Icon prefix |

```bash
# Example: white on purple
set -g @worktree-colors "#f8f8f2 #bd93f9"
set -g @worktree-icon "🌳"
```
