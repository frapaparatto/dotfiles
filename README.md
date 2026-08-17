# dotfiles

Personal dotfiles, managed with GNU Stow. Each top-level directory is a stow package:

- `bin` tmux-sessionizer script
- `git` gitconfig and global gitignore
- `nvim` neovim config (lazy.nvim)
- `tmux` tmux config
- `vim` vimrc (vim-plug)
- `zsh` zshrc and zprofile

## Setup

```
./setup
```

This installs Homebrew, runs `brew bundle` from the `Brewfile`, installs oh-my-zsh and tpm, backs up any conflicting files in `~/.dotfiles-backup`, then stows all packages.

Useful flags:

* `--dry` prints what would happen without changing anything
* `./setup nvim tmux` stows only the named packages

Safe to run more than once.
