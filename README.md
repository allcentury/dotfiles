## Dot Files by Anthony Ross

These dotfiles are a WIP, I will update the readme with install instructions once stable.

### Install

Full bootstrap (packages, oh-my-zsh, zplug, submodules, then symlinks):

```
./install/install.sh
```

Just (re)create the symlinks, no package installs:

```
./install/symlink.sh
```

Current font:

* InconsolataLGCNerdFontMono-Regular - https://www.nerdfonts.com/font-downloads

### Updating tmux-worktree

`tmux-worktree/` is vendored as a git subtree. To pull upstream changes:

```
git subtree pull --prefix=tmux-worktree git@github.com:antross-brex/tmux-worktree.git main --squash
```
