#!/bin/fish
# Accessing Snips , the above is being made for that purpose 
# ssh -i <key> snips.sh
# Then you can send a file like this 
# bat pantysmell.txt | ssh -i bootylick snips.sh 
# Change persmission to fix errors 
# chmod 600 *

ssh-keygen -t ed25519 

echo "...changing permission to 600.."
echo " chmod 600 *"
chmod 600 *