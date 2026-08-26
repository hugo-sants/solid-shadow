# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Custom Tab behavior
_zsh_tab() {
    POSTDISPLAY=""
    zle expand-or-complete
}

zle -N _zsh_tab
bindkey '^I' _zsh_tab

# Powerlevel10k configuration
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

# User-local binaries
export PATH="$HOME/.local/bin:$PATH"

# eza
export EZA_COLORS="di=38;2;109;198;243"

# Zsh syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=white'
ZSH_HIGHLIGHT_STYLES[path]='fg=white'

# User aliases and functions
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] &&
    source "$HOME/.config/zsh/aliases.zsh"

[[ -f "$HOME/.config/zsh/functions.zsh" ]] &&
    source "$HOME/.config/zsh/functions.zsh"

# Command to resolve transparency issues in inactive windows (optional):
# sed -i 's/^        background-color: @window_backdrop_color;$/       \/\* background-color: @window_backdrop_color; \*\//' ~/.config/gtk-4.# 0/gtk.css && touch ~/.config/gtk-4.0/gtk.css
