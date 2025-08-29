#!/bin/fish 
echo "
 ███╗   ███╗  █████╗  ███╗   ██╗ ██╗ ███╗   ███╗
 ████╗ ████║ ██╔══██╗ ████╗  ██║ ██║ ████╗ ████║
 ██╔████╔██║ ███████║ ██╔██╗ ██║ ██║ ██╔████╔██║
 ██║╚██╔╝██║ ██╔══██║ ██║╚██╗██║ ██║ ██║╚██╔╝██║
 ██║ ╚═╝ ██║ ██║  ██║ ██║ ╚████║ ██║ ██║ ╚═╝ ██║
 ╚═╝     ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝ ╚═╝ ╚═╝     ╚═╝"
echo " ====================================== "
echo " Make custom animations in python, have mistress fart in your nose"
echo "This will install manim in your system"
echo " Main Website - https://docs.manim.community/en/stable/installation/linux.html "
echo " This fish will run the following commands "
echo "  - sudo apt update"
echo "  - sudo apt install build-essential python3-dev libcairo2-dev libpango1.0-dev ffmpeg"
echo "  - pip3 install manim "
sudo apt install build-essential python3-dev libcairo2-dev libpango1.0-dev ffmpeg -y
pip3 install manim
manim 