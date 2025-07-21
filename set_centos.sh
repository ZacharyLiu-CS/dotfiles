cp .vimrc ~

ohmyzsh_dir="$HOME/.oh-my-zsh"
if [ -d "$ohmyzsh_dir" ]; then
    echo "[INFO] oh-my-zsh is already installed at $ohmyzsh_dir"
else
    echo "[CLONE] Installing oh-my-zsh..."
    bash ./install_oh_my_zsh.sh
fi


cp centos.zshrc ~/.zshrc
cp .oh-my-zsh-themes/dpoggi.zsh-theme ~/.oh-my-zsh/themes/

# Git setup
git config --global user.email "zacharyzliu@tencent.com"
git config --global user.name "zacharyzliu"

sudo yum install tmux python

# tmux plugin manager
tmux_plugins_dir="$HOME/.tmux/plugins/tpm"
if [ -d "$tmux_plugins_dir" ]; then
    echo "[INFO] tpm is already installed at $tmux_plugins_dir"
else
    echo "[CLONE] Installing tpm..."
    if git clone https://github.com/tmux-plugins/tpm "$tmux_plugins_dir"; then
        echo "[SUCCESS] tpm cloned successfully."
    else
        echo "[ERROR] Failed to clone tpm. Check network or permissions."
        exit 1
    fi
fi

tmux_conf_src=".tmux.conf"
tmux_conf_dest="$HOME/.tmux.conf"
if [ -f "$tmux_conf_src" ]; then
    if cp "$tmux_conf_src" "$tmux_conf_dest"; then
        echo "[SUCCESS] Copied .tmux.conf to $tmux_conf_dest"
    else
        echo "[ERROR] Failed to copy .tmux.conf. Check file permissions."
    fi
else
    echo "[WARN] Source file .tmux.conf not found. Skipping copy."
fi

# Zsh plugins
zsh_custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
mkdir -p "$zsh_custom_dir"

clone_zsh_plugin() {
    local repo_url="$1"
    local plugin_name=$(basename "$repo_url" .git)
    local target_dir="$zsh_custom_dir/$plugin_name"

    if [ -d "$target_dir" ]; then
        echo "[INFO] $plugin_name is already installed at $target_dir"
    else
        echo "[CLONE] Installing $plugin_name..."
        if git clone "$repo_url" "$target_dir"; then
            echo "[SUCCESS] $plugin_name cloned successfully."
        else
            echo "[ERROR] Failed to clone $plugin_name. Check URL or SSH keys[6,11](@ref)."
            return 1
        fi
    fi
}

clone_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions.git"
clone_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git"

# Autojump
autojump_dir="$HOME/autojump"
if [ -d "$autojump_dir" ]; then
    echo "[INFO] autojump is already installed at $autojump_dir"
else
    echo "[CLONE] Installing autojump..."
    if git clone https://github.com/joelthelion/autojump.git "$autojump_dir"; then
        cd "$autojump_dir" || exit 1
        if python3 ./install.py; then
            echo "[SUCCESS] autojump installed. Add 'source \$HOME/.autojump/etc/profile.d/autojump.sh' to your .zshrc"
        else
            echo "[ERROR] autojump installation script failed. Check Python environment."
            exit 1
        fi
    else
        echo "[ERROR] Failed to clone autojump. Check network or SSH keys[6,11](@ref)."
        exit 1
    fi
fi
exec zsh

