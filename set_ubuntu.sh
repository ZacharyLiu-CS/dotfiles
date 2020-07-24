sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo apt update
sudo apt upgrade
sudo apt install -f vim
sudo apt install -f zsh
sudo apt install -f build-essential
sudo apt install -f git
sudo apt install -f htop
sudo apt install -f nodejs
sudo apt install -f curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
sudo cp ~/linuxconfig/.vimrc ~
git config --global user.email "liuzhenm@mail.ustc.edu.cn"
git config --global user.name "liuzhen"
git config --global push.default matching
git clone https://github.com/ZacharLiu-CS/linuxconfig.git ~
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start sshd
sudo apt install -f tmux
cp ~/linuxconfig/.tmux.conf ~
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
