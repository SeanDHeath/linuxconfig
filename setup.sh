#!/bin/bash
dir=$(pwd)
echo "Installing packages"
yay -S --needed $(cat $dir/packages)

echo "Fixing libvirt group"
sudo usermod -aG libvirt libvirt $USER

echo "Installing nordnm"
sudo -H pip install nordnm

echo "Installing Rust"
if [ -e "/usr/local/bin/rustup" ]  ; then
  echo "Rust already installed"
else
  sudo curl -o /usr/local/bin/rustup https://sh.rustup.rs
  sudo chmod 0755 /usr/local/bin/rustup
  rustup -y
fi

echo "Setting up vim"
if [ -e "~/.vim" ] ; then
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

echo "Setting up bash"
if [ -e "~/.bash" ] ; then
  echo "bash already set up"
else
  git clone https://github.com/seandheath/bash.git ~/.bash
  cd ~/.bash
  /bin/bash setup.sh
  cd $dir
fi

echo "Setting up PEDA"
if [ -e "/opt/peda" ] ; then
  echo "PEDA already set up"
else
  sudo git clone https://github.com/longld/peda.git /opt/peda
  echo "source /opt/peda/peda.py" >> ~/.gdbinit
fi

echo "Fixing touchpad"
if [ -e "/lib/systemd/system-sleep/touchpad" ] ; then
  echo "touchpad already fixed"
else
  sudo cp $dir/files/touchpad /lib/systemd/system-sleep/touchpad
  sudo chmod 0755 /lib/systemd/system-sleep/touchpad
fi

echo "Cleaning up directories"
rmdir Music Pictures Public Templates Videos
