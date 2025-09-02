# Zsh Config

# Prompt
if [[ -n "$DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
    # In GUI Terminal
    if [[ $EUID -eq 0 ]]; then
        # Root prompt: red
        PS1=' %F{8}%~ %F{1}root%F{8}:%f '
    else
        # User prompt: cyan
        PS1=' %F{8}%~ %F{6}jwno%F{8}:%f '
    fi
else
    # In TTY Terminal
    if [[ $EUID -eq 0 ]]; then
        # Root prompt: red
        PS1=' %F{7}%~ %F{1}root%F{7}:%f '
    else
        # User prompt: cyan
        PS1=' %F{7}%~ %F{6}jwno%F{7}:%f '
    fi
fi

# Path configuration
export PATH="$HOME/.local/bin:$PATH"

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export XCURSOR_THEME="BreezeX-RosePine-Linux"
export XCURSOR_SIZE=24
export GTK_THEME="Adwaita"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export QT_STYLE_OVERRIDE=adwaita-dark

# Common aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -al'
alias shutdown='sudo shutdown now'
alias reboot='sudo reboot now'
alias guiq='~/.local/bin/start-qtile.sh'
alias wifi-list='nmcli device wifi list'
alias wifi-connect='sudo nmcli device wifi connect'
alias wifi-down='sudo nmcli connection down'
alias vpnup='sudo wg-quick up wg-NL-FREE-235'
alias vpndown='sudo wg-quick down wg-NL-FREE-235'

# User-specific functions (only for regular user, not root)
if [[ $EUID -ne 0 ]]; then
    # Configuration management
    update_root() {
        echo "Updating both user and root .zshrc files..."
        sudo cp ~/.zshrc /root/.zshrc
        sudo cp ~/.config/nvim/init.lua /root/.config/nvim/init.lua
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
fastfetch --logo none

# ZSH-Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ZSH-Syntax-Highlighting
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
