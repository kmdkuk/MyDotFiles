#! /bin/sh
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code
rm -f microsoft.gpg

git clone git@github.com:kmdkuk/vscode-user-setting.git ~/vscode-user-setting
rm -rf /home/kmdkuk/.config/Code/User/
ln -s $HOME/vscode-user-setting/User $HOME/.config/Code/User

npm i -g bash-language-server
