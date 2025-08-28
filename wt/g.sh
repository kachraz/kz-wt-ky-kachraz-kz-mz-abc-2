#!/bin/bash 
echo "==================="
echo ""
echo "git add -all && git commit -m <addurshit>&& git push"
git add --all 
git commit -m "🫦"
git push --progress
echo ""
echo "=========PUSH DONE========="
echo ""
echo "==================="
echo "View Git log last 10"
echo ""
git log --oneline --graph --decorate -10 
echo ""
echo "=========LOGDONE========="
echo ""
echo " View all branches "
echo ""
git branch -a 
echo ""
echo "=========BranchesDone========="
echo ""
echo "View Status "
git status 
echo ""
echo "=========StatusDone========="