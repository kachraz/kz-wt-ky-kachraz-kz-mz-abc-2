#!/usr/bin/env fish 
echo -e ""
echo -e ""
echo -e (set_color 02FEEC) "----------------------"
echo -e ""
echo -e " Installing Solidity Panty"
echo -e ""
echo -e " Foundry : curl -L https://foundry.paradigm.xyz | bash"
echo -e " Aderyn  : curl -L https://raw.githubusercontent.com/Cyfrin/aderyn/dev/cyfrinup/install | bash "
echo -e " Soldeer : cargo install soldeer"
echo -e ""
echo -e "----------------------"
echo -e (set_color 06D001)""
echo -e " Installing Foundry..."
curl -L https://foundry.paradigm.xyz | bash 
foundrup
mkdir -p $HOME/.config/fish/completions
forge completions fish > $HOME/.config/fish/completions/forge.fish
cast completions fish > $HOME/.config/fish/completions/cast.fish
anvil completions fish > $HOME/.config/fish/completions/anvil.fish
source $HOME/.config/fish/config.fish
echo -e ""
echo -e "Installing Aderyn"
brew install cyfrin/tap/aderyn
echo -e ""
echo -e " Now restart the shell and run the following"
echo -e (set_color F9E400)""
echo -e "foundryup "
echo -e "cyfrinup"
echo -e "" 
echo -e "" 