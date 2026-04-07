# ============================
# ZSH Fast Startup & Universal Config
# For ALL Linux Distributions
# ============================

# Instant prompt (p10k compatible)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Async load compinit for faster startup
_autoload_modules() {
  autoload -Uz compinit colors
  compinit -i -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
  colors
}
_autoload_modules &!

# Basic ZSH Options
setopt prompt_subst correct extendedglob nocaseglob autocd nobeep
setopt appendhistory histignorealldups sharehistory histignorespace
setopt autopushd pushdignoredups nocheckjobs numericglobsort

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HIST_STAMPS=mm/dd/yyyy

# Completion Settings
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh-cache"
zstyle ':completion:*' menu select interactive

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Default Editor
export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/nano

# ============================
# Plugin Loading (Cross-distro Paths)
# ============================
if [[ -d /usr/share/zsh/plugins ]]; then
  plugin_dir="/usr/share/zsh/plugins"
elif [[ -d /usr/local/share/zsh/plugins ]]; then
  plugin_dir="/usr/local/share/zsh/plugins"
elif [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins ]]; then
  plugin_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"
fi

if [[ -n "$plugin_dir" ]]; then
  if [[ -f "${plugin_dir}/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
    source "${plugin_dir}/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
  fi

  # Load syntax-highlighting asynchronously
  {
    zsh-syntax-highlighting_async() {
      if [[ -f "${plugin_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        source "${plugin_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      fi
    }
    zsh-syntax-highlighting_async &!
  }
fi

# ============================
# Key Bindings
# ============================
bindkey -e
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word
bindkey '^[[Z' undo

bindkey '\e[A' up-line-or-search
bindkey '\eOA' up-line-or-search
bindkey '\e[B' down-line-or-select
bindkey '\eOB' down-line-or-select
bindkey '\0' list-expand
bindkey -M menuselect '\r' .accept-line

zle -A {.,}history-incremental-search-forward
zle -A {.,}history-incremental-search-backward

# ============================
# Aliases
# ============================
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias df='df -h'
alias free='free -h'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias mkdir='mkdir -p'
alias ping='ping -c 5'
alias gitu='git add . && git commit -m "Update" && git push'

# ============================
# Prompt Style
# ============================
PROMPT="%B%F{cyan}%(4~|%-1~/.../%2~|%~)%f%b %B%(?.%F{cyan}.%F{red})➜ %f%b"
RPROMPT="%(?..%F{red}[%?]%f) %F{240}%*%f"

# Welcome Info
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  echo -e "\e[97m$USER@$HOST\e[0m  \e[36m$PRETTY_NAME\e[0m  \e[32m$(uname -r)\e[0m"
fi

# ============================
# Colored Man Pages
# ============================
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS='-R'

# ============================
# Autocomplete Behavior
# ============================
zstyle ':autocomplete:*' min-delay 0.05
zstyle ':autocomplete:*' list-lines 24
zstyle ':autocomplete:*' insert-unambiguous no
zstyle ':autocomplete:*' widget-style complete-word
zstyle ':autocomplete:*' add-space executables aliases functions

# ============================
# Universal Extract Function
# ============================
extract() {
  [ -f "$1" ] || { echo "Not a file"; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.zip)            unzip "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.7z)             7z x "$1" ;;
    *)                echo "Unsupported archive format" ;;
  esac
}

# ============================
# fzf Integration
# ============================
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS="--height 40% --border --color=light --layout=reverse"
  for f in /usr/share/fzf/{completion,key-bindings}.zsh /usr/local/share/fzf/{completion,key-bindings}.zsh; do
    [[ -f $f ]] && source $f
  done
  bindkey '^R' fzf-history-widget
fi

# ============================
# zoxide Integration
# ============================
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias zz='z -i'
fi

# ============================
# Dart Completion (Optional)
# ============================
[[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh

# ============================
# Auto-install Missing Commands
# Works on Arch / Debian / Ubuntu / Fedora / RHEL / SUSE
# ============================
command_not_found_handler() {
  local cmd="$1"
  printf "\e[33m[*] Command not found: %s\n\e[0m" "$cmd"

  local pm install_cmd
  if command -v pacman &>/dev/null; then
    pm=pacman
    install_cmd="sudo pacman -S --noconfirm"
  elif command -v apt &>/dev/null; then
    pm=apt
    install_cmd="sudo apt install -y"
  elif command -v dnf &>/dev/null; then
    pm=dnf
    install_cmd="sudo dnf install -y"
  elif command -v yum &>/dev/null; then
    pm=yum
    install_cmd="sudo yum install -y"
  elif command -v zypper &>/dev/null; then
    pm=zypper
    install_cmd="sudo zypper install -y"
  else
    printf "\e[31m[!] No supported package manager\n\e[0m"
    return 1
  fi

  printf "\e[32m[+] Trying to install package: %s\n\e[0m" "$cmd"
  if eval "$install_cmd $cmd"; then
    printf "\e[32m[+] Installed successfully\n\e[0m"
    return 0
  fi

  printf "\e[33m[*] Searching for provider package...\n\e[0m"
  local pkgs=""

  case "$pm" in
    pacman)
      ! command -v pkgfile &>/dev/null && sudo pacman -S --noconfirm pkgfile && pkgfile -u
      pkgs=$(pkgfile -b "$cmd" | head -1)
      ;;
    apt)
      ! command -v apt-file &>/dev/null && sudo apt update && sudo apt install -y apt-file && apt-file update
      pkgs=$(apt-file search -x "^/usr/bin/$cmd$|^/bin/$cmd$" | awk -F: 'NR==1{print $1}')
      ;;
    dnf|yum)
      pkgs=$(eval "$pm provides $cmd" | grep -E 'repo' | awk 'NR==1{print $1}')
      ;;
    zypper)
      pkgs=$(zypper search -x "$cmd" | grep '^i' | awk 'NR==1{print $2}')
      ;;
  esac

  if [[ -z "$pkgs" ]]; then
    printf "\e[31m[!] No package found for command: %s\n\e[0m" "$cmd"
    return 1
  fi

  printf "\e[32m[+] Found: %s\n\e[0m" "$pkgs"
  read -r -p "Install it now? [Y/n] " ans
  [[ -z "$ans" || "$ans" == [Yy] ]] && eval "$install_cmd $pkgs"
}

unset -f _autoload_modules
