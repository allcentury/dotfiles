#1 bin/bash

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

"source /usr/local/share/chruby/chruby.sh" >> ~/.bashrc
"source /usr/local/share/chruby/auto.sh" >> ~/.bashrc
