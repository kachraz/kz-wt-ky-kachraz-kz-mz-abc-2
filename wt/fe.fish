#!/usr/bin/env fish
echo ""
echo (set_color FEDB39)"***"
echo (set_color FEDB39)"This script is for downloading this folder"
echo (set_color FEDB39)"without git clone bastar"
echo (set_color FEDB39)"***"
echo (set_color FEDB39)"https://github.com/sniffowomo/sn-solbf-1/tree/ns/y"
echo (set_color FEDB39)"***"
echo (set_color FEDB39)"Installer fetch"
echo (set_color blue) ">brew install fetch "
brew install fetch
echo ""
echo (set_color 16FF00)"DONE--DONE--DONE"
echo ""
echo
echo (set_color B3005E)"2 - Actual Downnload"
echo (set_color blue) ">brew install fetch "
echo ""
echo "Where to download ?:"
read -l diro
echo (set_color blue ) "fetch \\"
echo (set_color blue ) "    --repo="https://github.com/sniffowomo/sn-solbf-1 \\" "
echo (set_color blue ) "    --branch="ns" \\"
echo (set_color blue ) "    --source-path="y" \\"
echo (set_color blue ) "    --progress \\ "
echo (set_color blue ) "    $diro "
fetch \
    --repo="https://github.com/sniffowomo/sn-solbf-1" \
    --branch="ns" \
    --source-path="y" \
    --progress \
    $diro
ls -al $diro
chmod +x $diro/*.sh
chmod +x $dir/*.fish
rm $dir/*.webp
echo (set_color 16FF00)"DONE--DONE--DONE"

