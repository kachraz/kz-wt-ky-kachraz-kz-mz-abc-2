#!/bin/bash
curl -L https://foundry.paradigm.xyz | bash
foundrup
mkdir -p $HOME/.config/fish/completions
forge completions fish >$HOME/.config/fish/completions/forge.fish
cast completions fish >$HOME/.config/fish/completions/cast.fish
anvil completions fish >$HOME/.config/fish/completions/anvil.fish
source $HOME/.config/fish/config.fish
