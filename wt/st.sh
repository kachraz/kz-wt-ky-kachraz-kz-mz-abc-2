#!/bin/bash
echo "####### SET ENVIRONMENT FOR RUST AND BREW"
source "$HOME/.profile"
source "$HOME/.cargo/env"
echo "#############Setup Fish#############"
echo "#############Setup Fish#############"
echo "#############Setup Fish#############"
echo "#############Setup Fish#############"
sudo apt-add-repository ppa:fish-shell/release-4 -y
sudo apt update
sudo apt install fish -y
echo ""
echo "==================================="
echo ""
echo "############# Fup #############"
echo "############# Fup #############"
echo "############# Fup #############"
echo "############# Fup #############"
echo "***"
echo ""
echo ""
echo " This bash script will run commands for a full update "
echo " commands have been taken from this site "
echo ""
echo " https://null-byte.wonderhowto.com/how-to/top-10-things-do-after-installing-kali-linux-0186450/"
echo ""
echo "   Commands that will be run "
echo "   --------------------------"
echo "       sudo apt-get update "
echo "       sudo apt-get dist-upgrade -Vy "
echo "       sudo apt-get autoremove -y "
echo "       sudo apt-get autoclean "
echo "       sudo apt-get clean "
echo "       cargo install-update -a"
echo "       cargo install cargo-update"
echo "       rustup update"
echo "       sudo apt-add-repository ppa:fish-shell/release-3 -y"
echo "       sudo apt-get install fish"
echo "       sudo apt install libwebkit2gtk-4.0-dev libgtk-3-dev libappindicator3-dev -y"
echo "       sudo apt-add-repository ppa:fish-shell/release-3"
echo "       sudo apt-get install fish"
echo ""
sudo apt-get update
sudo apt-get dist-upgrade -Vy
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean
sudo apt install cmake -y
sudo apt install neofetch -y
cargo install-update -a
cargo install cargo-update
cargo install --locked cargo-modules
rustup update
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt install libwebkit2gtk-4.0-dev libgtk-3-dev libappindicator3-dev -y
sudo apt-get install fish -y
sudo apt install openvpn -y
echo ""
echo ""
echo ""
echo "Version of Kali "
echo "This will be executed with the command $ lbs_release -a"
echo ""
lsb_release -a
echo ""
echo ""
echo " Now lets see the version with neofetch command $ neofetch"
echo ""
neofetch
echo ""
echo ""
echo "############### CARGO INSTALLS ###############"
echo "############### CARGO INSTALLS ###############"
echo "############### CARGO INSTALLS ###############"
echo "############### CARGO INSTALLS ###############"
cargo install exa fd-find ripgrep du-dust starship bat artem nu image-to-ascii lolcrab prettydiff cfonts
cargo install cargo-nextest --locked
echo ""
echo ""
echo "############### BREW INSTALLS ###############"
echo "############### BREW INSTALLS ###############"
echo "############### BREW INSTALLS ###############"
brew install fzf helix
yes | /home/linuxbrew/.linuxbrew/opt/fzf/install
fzf_key_bindings
echo ""
echo ""
echo "############ STARSHIP ########################"
echo "############ STARSHIP ########################"
echo "############ STARSHIP ########################"
echo -e " First Install for Fish Shell"
echo "starship init fish | source" >~/.config/fish/config.fish
starship preset pure-preset >~/.config/starship.toml
# And add the following to the end of your Nushell configuration (find it by running $nu.config-path
#source ~/.cache/starship/init.n
echo "###### Add shit to config fish ##########"
echo "Pulling down config.fish --->"
echo "cp ./gwz/config.fish ~/.config/fish/"
cp ./lq/config2.fish ~/.config/fish/
