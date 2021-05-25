#!/usr/bin/env bash

ln -s ~/MyDotFiles/.tmux.osx.conf ~/.tmux.local.conf
mkdir -p ~/bin
ln -s ~/MyDotFiles/bin/osx/get_battery_tmux ~/bin/get_battery_tmux
ln -s ~/MyDotFiles/bin/osx/get_load_average_tmux ~/bin/get_load_average_tmux
ln -s ~/MyDotFiles/bin/osx/get_ssid_tmux ~/bin/get_ssid_tmux
ln -s ~/MyDotFiles/bin/osx/get_volume_tmux ~/bin/get_volume_tmux
ln -s ~/MyDotFiles/.zshrc ~/.zshrc

