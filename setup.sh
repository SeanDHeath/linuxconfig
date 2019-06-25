#!/bin/bash
say="figlet -f small -c"
dir=$(pwd)
sudo sed -i -e "s/#MAKEFLAGS=.*/MAKEFLAGS=\"-j$(nproc --all)\"/g"
yay -S --needed --noconfirm figlet
$say "Installing packages"

yay -S --needed --noconfirm $(cat $dir/packages)

$say "Fixing libvirt group"
sudo usermod -aG libvirt $USER

$say "Installing nordnm"
sudo -H pip install nordnm

$say "Installing Rust"
if [ -e "/usr/local/bin/rustup" ]  ; then
  echo "Rust already installed"
else
  sudo curl -o /usr/local/bin/rustup https://sh.rustup.rs
  sudo chmod 0755 /usr/local/bin/rustup
  rustup -y
fi

$say "Setting up vim"
if [ -d "$HOME/.vim/" ]; then
  echo "vim already installed"
else
  git clone https://github.com/seandheath/vim.git ~/.vim
  cd ~/.vim
  /bin/bash setup.sh
  cd ~/.vim/plugged/YouCompleteMe
  git submodule update --init --recursive
  . ~/.cargo/env && python ~/.vim/plugged/YouCompleteMe/install.py --clang-completer --rust-completer --go-completer
  cd $dir
fi

$say "Setting up bash"
if [ -d "$HOME/.bash/" ]; then
  echo "bash already set up"
else
  git clone https://github.com/seandheath/bash.git ~/.bash
  cd ~/.bash
  /bin/bash setup.sh
  cd $dir
fi

$say "Setting up PEDA"
if [ -d "/opt/peda/" ]; then
  echo "PEDA already set up"
else
  sudo git clone https://github.com/longld/peda.git /opt/peda
  echo "source /opt/peda/peda.py" >> ~/.gdbinit
fi

$say "Fixing touchpad"
if [ -e "/lib/systemd/system-sleep/touchpad" ]; then
  echo "touchpad already fixed"
else
  sudo cp $dir/files/touchpad /lib/systemd/system-sleep/touchpad
  sudo chmod 0755 /lib/systemd/system-sleep/touchpad
fi

$say "Cleaning up directories"
rmdir ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
