HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt correct
setopt autocd

autoload -U colors && colors

autoload -Uz compinit
compinit

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="vim"

# ALIASES

alias ls='eza --icons always'
alias tree='eza --tree --icons always'
alias grep='grep --color=auto'
alias v='vim'
alias la='ls -la'
alias ll='ls -l'
alias ff='fastfetch'

eval "$(starship init zsh)"
