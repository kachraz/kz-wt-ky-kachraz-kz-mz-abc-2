#!/bin/fish 
cargo --version
rm -rf $HOME/.rustup/toolchains/
yes | curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
cargo --version

