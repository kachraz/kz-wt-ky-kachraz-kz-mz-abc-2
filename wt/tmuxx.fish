#!/usr/bin/env fish
echo " "
echo " This wil run the following commands  "
echo " 1. sudo apt-get install tmux -y = Install Tmux "
echo " 2. sudo apt install powerline -y = Intall tmux powewrline"
echo " 3. git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm = Install tmux plugins"
echo " 4. cp /workspace/ceh/st/.tmux.conf ~/.tmux.conf = copy .tmux.conf to ~"
echo ""
echo ""
echo ""

sudo apt-get install tmux -y
sudo apt install powerline -y 
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp /workspace/ceh/st/.tmux.conf ~/.tmux.conf
echo "Done ... Runinng tmux - tmux new -s w1"
tmux new -s w1
