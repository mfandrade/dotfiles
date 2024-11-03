# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory for Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download Zinit if it's not there yet
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit
source "$ZINIT_HOME/zinit.zsh"

# Add Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Zinit plugins zone
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load zsh-completions (including ASDF)
if [[ -f "$HOME/.asdf/asdf.zsh" ]]; then
  source "$HOME/.asdf/asdf.zsh"
  fpath=(${ASDF_DIR}/completions $fpath)
fi
autoload -U compinit && compinit

# Shell integrations
eval "$(fzf --zsh)"                 # enables fzf in C-r
eval "$(zoxide init --cmd cd zsh)"  # better cd command

# Completion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # completion case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colorful completion
zstyle ':completion:*' menu no                          # replaces C-r menu entries...
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'  # by fzf-tab preview
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Keybindings 
bindkey -e
bindkey '^p'  history-search-backward
bindkey '^n'  history-search-forward

# History control
HISTSIZE=999999
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.history.log
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups

# Aliases
[[ ! -f ~/.aliases.sh ]] || source ~/.aliases.sh
