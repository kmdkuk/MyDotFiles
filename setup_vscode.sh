#! /bin/zsh
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo -E install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo -E sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo -E apt install -y apt-transport-https
sudo -E apt update
sudo -E apt install -y code
rm -f microsoft.gpg

git clone https://github.com/kmdkuk/vscode-user-setting.git ${HOME}/vscode-user-setting
rm -rf ${HOME}/.config/Code/User/
ln -s ${HOME}/vscode-user-setting/User ${HOME}/.config/Code/User

# npm i -g bash-language-server
