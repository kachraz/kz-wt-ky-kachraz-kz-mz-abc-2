#!/bin/fish 
echo "Command for making wallets"
echo ""
echo "**************************************************"
echo ""
echo "How Many wallets to create ? - txt File will be created with the input number"
read -l wax
echo ""
echo "**************************************************"
for i in (seq 1 $wax)
    echo ""
    echo "---------------------------------------"
    echo "New Wallet $i"
    cast w n 
    echo "---------------------------------------"
end &> $wax.txt 