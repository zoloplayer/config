if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/.config/emacs/bin:$PATH"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
plugins=(git docker docker-compose zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export VISUAL='nvim'

alias cat='bat '

alias l='eza --header --color=always --long --git --no-user --no-permissions --icons=always --tree -L 1 '
# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias cl='clear'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init --cmd cd zsh)"


# Created by `pipx` on 2026-02-04 07:27:15
export PATH="$PATH:/Users/yashvitfuloria/.local/bin"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

if [[ -f "$HOME/fzf-git.sh/fzf-git.sh" ]]; then
  source "$HOME/fzf-git.sh/fzf-git.sh"
fi

show_file_or_dir_preview="if [ -d {} ]; then eza --header --color=always --long --git --no-user --no-permissions --icons=always --tree -L 1  {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --header --color=always --long --git --no-user --no-permissions --icons=always --tree -L 1  {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Torrent Search Engine
alias ts="python3 ~/Desktop/code/files/search.py"
alias ts-start="cd ~/Desktop/code/files && nohup ./target/release/torrent-search > server.log 2>&1 & echo \$! > server.pid && echo Server started"
alias ts-stop="kill \$(cat ~/Desktop/code/files/server.pid) && echo Server stopped"
alias ts-log="tail -f ~/Desktop/code/files/server.log"
alias ts-status="curl -s http://localhost:3000/health | python3 -m json.tool"


# Tortube
alias tortube='/Users/yashvitfuloria/Desktop/code/torrent-stream-engine/scripts/tortube'
