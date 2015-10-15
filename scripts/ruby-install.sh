#1 bin/bash

echo "Updating packages"
sudo apt-get -y update        # Fetches the list of available updates
sudo apt-get -y upgrade       # Strictly upgrades the current packages
sudo apt-get -y dist-upgrade  # Installs updates (new ones)
sudo apt-get install make
sudo apt-get -y update        # Fetches the list of available updates
sudo apt-get -y upgrade       # Strictly upgrades the current packages
sudo apt-get -y dist-upgrade  # Installs updates (new ones)
echo "Installing Git..."
sudo apt-get -y install git-core
echo "Removing system vim and replacing it with gtk"
sudo apt-get -y purge vim gvim vim-gtk
sudo apt-get -y install vim-gtk
echo "Installing tmux..."
sudo apt-get -y install tmux
echo "Installing silver searcher"
sudo apt-get -y install silversearcher-ag

# install chruby
echo "Installing chruby"
cd ~
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install

echo "Installing ruby-installer"
cd ~
wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
tar -xzvf ruby-install-0.5.0.tar.gz
cd ruby-install-0.5.0/
sudo make install

echo "Installing ruby 2.2.3"
cd ~
ruby-install ruby 2.2.3

echo "Adding chruby alias' to .bashrc"

echo "source /usr/local/share/chruby/chruby.sh" >> ~/.bashrc
echo "source /usr/local/share/chruby/auto.sh" >> ~/.bashrc
