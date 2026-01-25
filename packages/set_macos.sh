cp .vimrc ~

ohmyzsh_dir="$HOME/.oh-my-zsh"
if [ -d "$ohmyzsh_dir" ]; then
    echo "[INFO] oh-my-zsh is already installed at $ohmyzsh_dir"
else
    echo "[CLONE] Installing oh-my-zsh..."
    bash ./install_oh_my_zsh.sh
fi

copy_or_not() {
    # 1. --- 参数校验 ---
    # 检查是否提供了两个参数
    if [ "$#" -ne 2 ]; then
        # 将错误信息输出到标准错误流 (stderr)
        echo "错误: 使用方法: copy_or_not <source_file> <destination_file>" >&2
        return 1
    fi

    # 2. --- 变量赋值 ---
    # 使用 local 关键字声明局部变量，防止污染全局环境
    local source_file="$1"
    local dest_file="$2"
    local response

    # 3. --- 源文件检查 ---
    # 检查源文件是否存在且是一个普通文件
    if [ ! -f "$source_file" ]; then
        echo "错误: 源文件 '$source_file' 不存在或不是一个文件。" >&2
        return 1
    fi

    # 4. --- 核心逻辑：检查目标并提示 ---
    # 检查目标文件是否已存在
    if [ -f "$dest_file" ]; then
        # 如果存在，向用户提问
        # -r 防止反斜杠被解释, -p 直接显示提示信息
        read -r -p "目标文件 '$dest_file' 已存在，是否覆盖? [y/N] " response

        # 使用 case 语句判断用户输入
        case "$response" in
            # 匹配 y 或 Y 开头的任意回答 (yes, Y, y, etc.)
            [yY]*)
                # 用户同意，什么也不做，让程序继续执行到下面的复制步骤
                ;;
            *)
                # 其他所有情况（包括直接按回车）都视为取消
                echo "操作已取消。"
                return 0 # 操作被用户取消，属于“成功”退出
                ;;
        esac
    fi

    # 5. --- 执行复制 ---
    # 如果目标文件不存在，或用户同意覆盖，则执行此步骤
    # 使用 -p 选项可以保留源文件的元数据（如修改时间、权限等）
    cp -p "$source_file" "$dest_file"

    # 检查上一个命令（cp）是否成功执行
    if [ "$?" -eq 0 ]; then
        echo "成功: '$source_file' 已复制到 '$dest_file'。"
    else
        echo "错误: 复制文件时发生未知错误。" >&2
        return 1
    fi
}
copy_or_not macos.zshrc ~/.zshrc

sed -i '' "s/macos_name/$(whoami)/g" ~/.zshrc
cp .oh-my-zsh-themes/dpoggi.zsh-theme ~/.oh-my-zsh/themes/

# Git setup
git config --global user.email "liuzhenm@mail.ustc.edu.cn"
git config --global user.name "liuzhen"

brew install tmux python

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
zsh_custom_plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
zsh_custom_theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
mkdir -p "$zsh_custom_plugin_dir"
mkdir -p "$zsh_custom_theme_dir"

clone_zsh_plugin() {
    local repo_url="$1"
    local plugin_name=$(basename "$repo_url" .git)
    local target_dir="$zsh_custom_plugin_dir/$plugin_name"

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
clone_zsh_theme() {
    local repo_url="$1"
    local theme_name=$(basename "$repo_url" .git)
    local target_dir="$zsh_custom_theme_dir/$theme_name"

    if [ -d "$target_dir" ]; then
        echo "[INFO] $theme_name is already installed at $target_dir"
    else
        echo "[CLONE] Installing $theme_name..."
        if git clone "$repo_url" "$target_dir"; then
            echo "[SUCCESS] $theme_name cloned successfully."
        else
            echo "[ERROR] Failed to clone $theme_name. Check URL or SSH keys[6,11](@ref)."
            return 1
        fi
    fi
}

clone_zsh_plugin "git@github.com:zsh-users/zsh-autosuggestions.git"
clone_zsh_plugin "git@github.com:zsh-users/zsh-syntax-highlighting.git"
# see the configure https://github.com/spaceship-prompt/spaceship-prompt#
clone_zsh_theme "git@github.com:spaceship-prompt/spaceship-prompt.git"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"


# Autojump
autojump_dir="$HOME/autojump"
if [ -d "$autojump_dir" ]; then
    echo "[INFO] autojump is already installed at $autojump_dir"
else
    echo "[CLONE] Installing autojump..."
    if git clone git@github.com:joelthelion/autojump.git "$autojump_dir"; then
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

