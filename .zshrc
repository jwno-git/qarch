# Zsh Config

# Prompt
if [[ -n "$DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
    # In GUI Terminal
    if [[ $EUID -eq 0 ]]; then
        # Root prompt: red
        PS1=' %F{8}%~ %F{1}CMD%F{8}:%f '
    else
        # User prompt: cyan
        PS1=' %F{8}%~ %F{6}CMD%F{8}:%f '
    fi
else
    # In TTY Terminal
    if [[ $EUID -eq 0 ]]; then
        # Root prompt: red
        PS1=' %F{7}%~ %F{1}CMD%F{7}:%f '
    else
        # User prompt: cyan
        PS1=' %F{7}%~ %F{6}CMD%F{7}:%f '
    fi
fi

# Path configuration
export PATH="$HOME/.local/bin:$PATH"

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"

# Common aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -al'
alias shutdown='sudo shutdown now'
alias reboot='sudo reboot now'
alias wifi-list='nmcli device wifi list'
alias wifi-connect='sudo nmcli device wifi connect'
alias wifi-down='sudo nmcli connection down'

# User-specific functions (only for regular user, not root)
if [[ $EUID -ne 0 ]]; then
    # Configuration management
    update_root() {
        echo "Updating both user and root .zshrc files..."
        sudo cp ~/.zshrc /root/.zshrc
        sudo cp -r ~/.config/nvim /root/.config/
        echo "✓ Root updated"
        echo "Note: Changes will take effect on next shell session or after 'source ~/.zshrc'"
    }

    # Services Monitor
    service_status() {
        echo "=== FAILED SERVICES (Critical!) ==="
        systemctl list-units --type=service --state=failed --no-pager
        echo -e "\n=== RUNNING SERVICES ==="
        systemctl list-units --type=service --state=running --no-pager
        echo -e "\n=== EXITED SERVICES (One-shot completed) ==="
        systemctl list-units --type=service --state=exited --no-pager
        echo -e "\n=== INACTIVE SERVICES ==="
        systemctl list-units --type=service --state=inactive --no-pager
        echo "... (showing first 10 inactive services)"
    }
    
    ser_status() {
        service_status | less
    }
fi

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ -n "$DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
    exec tmux new-session -A -s main
fi

# Display configuration and conditional fastfetch
# fbset -g 2880 1800 2880 1800 32 2>/dev/null
clear

# ZSH-Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ZSH-Syntax-Highlighting
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
