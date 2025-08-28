function bal 

    # This function is for getting the balances of all of your accounts 
    # Wallets set 
    # w1 0x0F971095798624F131Bc598E312420e37681773e
    # w2 0x656C54eF377e15791956488a683Ade639019f7B0
    # w3 0x9d0f5cf1614fB09fd55a9be0F444887Ac8aFBc6D
    # w4 0x326C885267bfC530964e49a76aD8d9A6FE871F9C

    # Set Variables - Just Jeep changin this all the
    # Wallets 
    set A1 0x0F971095798624F131Bc598E312420e37681773e
    set A2 0x656C54eF377e15791956488a683Ade639019f7B0
    set A3 0x9d0f5cf1614fB09fd55a9be0F444887Ac8aFBc6D
    set A4 0x326C885267bfC530964e49a76aD8d9A6FE871F9C

    # Set RPC here 
    set GOE https://eth-goerli.g.alchemy.com/v2/wfowE284fYsqh-laeF5qmjOTQ3YTwuX_  
    set MUM https://polygon-mumbai.g.alchemy.com/v2/DlxcFxU5u-OioYGMvKhwWsAzAknhvQYd
    set SEP https://sepolia.infura.io/v3/4d9f7fa54ce44d1aa3319dca50aa3dd7
    set BSC https://sparkling-boldest-brook.bsc-testnet.discover.quiknode.pro/9c0a1ccf523e238a5e6d574a36ea192f5fcfb747

    # Actual Code starts here 

    clear
    # Displaying todays rates 
    # Today Eth Rate
    set today_eth_rate (curl -s rate.sx/1ETH)
    set today_bnb_rate (curl -s rate.sx/1BNB)
    
    # Aesthetic Display
    echo "---"
    echo "Todays ETH Rate" $today_eth_rate
    echo "Todays BNB Rate" $today_bnb_rate
    echo ""
    echo (set_color ff0000)"############################ Balances ##################################"
    echo ""
    echo (set_color 0000ff)"***********************************************************************"
    echo (set_color 0000ff)""
    echo (set_color 0000ff)"WRL1  : 0x0F971095798624F131Bc598E312420e37681773e "
    echo (set_color 0000ff)"WRL1K : 0x80d01136bb692a0daf9dad81923668d0f91c1fe8b578cde4624f0e128caa48ae"
    echo (set_color 0000ff)""
    echo (set_color 0000ff)"***********************************************************************"
    set w1g (cast balance $A1 --rpc-url $GOE ) 
    set w1m (cast balance $A1 --rpc-url $MUM ) 
    set w1s (cast balance $A1 --rpc-url $SEP ) 
    set w1b (cast balance $A1 --rpc-url $BSC ) 
    echo (set_color 0000ff)"Goerli    :" $w1g
    echo (set_color 0000ff)"Matic     :" $w1m
    echo (set_color 0000ff)"Sepolia   :" $w1s
    echo (set_color 0000ff)"Binance   :" $w1b
    echo ""
    echo (set_color ff0000)"-----------------------------------------------------------------------"
    echo " "
    echo (set_color ee82ee)"***********************************************************************"
    echo (set_color ee82ee)""
    echo (set_color ee82ee)"WRL2  : 0x656C54eF377e15791956488a683Ade639019f7B0"
    echo (set_color ee82ee)"WRL2K : 0x5f274ff41624e0c59333681266d4a8138bf5c9ce7fc9798414b9a7745365526c"
    echo (set_color ee82ee)""
    echo (set_color ee82ee)"***********************************************************************"
    set w1g (cast balance $A2 --rpc-url $GOE )
    set w1m (cast balance $A2 --rpc-url $MUM )
    set w1s (cast balance $A2 --rpc-url $SEP )
    set w1b (cast balance $A2 --rpc-url $BSC )
    echo (set_color ee82ee)"Goerli    :" $w1g
    echo (set_color ee82ee)"Matic     :" $w1m
    echo (set_color ee82ee)"Sepolia   :" $w1s
    echo (set_color ee82ee)"Binance   :" $w1b
    echo ""
    echo (set_color ff0000)"-------------------------------------------------------------------------"
    echo ""
    echo (set_color 3cb371)"***********************************************************************"
    echo (set_color 3cb371)""
    echo (set_color 3cb371)"WRL3  : 0x9d0f5cf1614fB09fd55a9be0F444887Ac8aFBc6D"
    echo (set_color 3cb371)"WRL3K : 0x305a8df66f6651beee74d31cd612806ee7e3060071586e12c5f8a29b947e81a1"
    echo (set_color 3cb371)""
    echo (set_color 3cb371)"***********************************************************************"
    set w1g (cast balance $A3 --rpc-url $GOE)
    set w1m (cast balance $A3 --rpc-url $MUM)
    set w1s (cast balance $A3 --rpc-url $SEP)
    set w1b (cast balance $A3 --rpc-url $BSC)
    echo (set_color 3cb371)"Goerli    :" $w1g
    echo (set_color 3cb371)"Matic     :" $w1m
    echo (set_color 3cb371)"Sepolia   :" $w1s
    echo (set_color 3cb371)"Binance   :" $w1b
    echo ""
    echo (set_color ff0000)"-------------------------------------------------------------------------"
    echo " "
    echo (set_color ffa500)"***********************************************************************"
    echo (set_color ffa500)""
    echo (set_color ffa500)"WRL4  : 0x326C885267bfC530964e49a76aD8d9A6FE871F9C"
    echo (set_color ffa500)"WRL4K : 0x45a8e7ed4f2f3bfbaf433fc7ef471cdf61e91d4135249b16aa51c39562b0aa29"
    echo (set_color ffa500)""
    echo (set_color ffa500)"***********************************************************************"
    set w1g (cast balance $A4 --rpc-url $GOE)
    set w1m (cast balance $A4 --rpc-url $MUM)
    set w1s (cast balance $A4 --rpc-url $SEP)
    set w1b (cast balance $A4 --rpc-url $BSC)
    echo (set_color ffa500)"Goerli    :" $w1g
    echo (set_color ffa500)"Matic     :" $w1m
    echo (set_color ffa500)"Sepolia   :" $w1s
    echo (set_color ffa500)"Binance   :" $w1b
    echo ""
    echo (set_color ff0000)"-------------------------------------------------------------------------"
    echo " "
    echo (set_color ff0000)"################################ END ####################################"


end