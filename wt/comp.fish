#!/bin/fish
function comp
    echo ""
    echo ""
    echo " The following commands will b executed with this "
    echo (set_color FF55BB) " tar cvf - * | xz -T0 -9e -c > panty.tar.xz "
    echo (set_color 16FF00) " xz --list panty.tar.xz "
    tar cvf - * | xz -T0 -9e -c > panty.tar.xz
    xz --list panty.tar.xz
    ls -al panty.tar.xz
    curl  https://snips.sh/f/5d1unzQuUf
    echo " Decompresss= : tar -xvf panty.tar.xz -C <sniff - makedirectoryfirst>  "
    echo ""
    echo " # To Split the file use this syntax "
    echo " split -b 10M -d pan1.tar.xz pan1.tar.xz.part"
    echo " # Reassemble with "
    echo " cat pty.tar.xz.* > pty.tar.xz "
    echo " Then DC normally liek above "
    echo " # Send the file for sharing via cli"
    echo " curl bashupload.com -T StinkyMistressWorship.txt"

end
