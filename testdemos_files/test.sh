#!/bin/bash

chown root ~
# rsync -a deps/regamedll/* .
rsync -a deps/rehlds/* .
# mv $GITHUB_WORKSPACE/tests/swds.dll .

descs=(
    # "CS: Testing jumping, scenarios, shooting etc"
    "CS: Multiplayer"
    # "Half-Life: Physics singleplayer"
    # "Half-Life: Multiplayer on crossfire map"
    # "Half-Life: Shooting with several weapons"
)
demos=(
    # "cstrike-basic-1" 
    "cstrike-muliplayer-1"
    # "rehlds-phys-single1"
    # "crossfire-1-multiplayer-1"
    # "shooting-hl-1"
)
retVal=0
for i in "${!demos[@]}"; do
    params=$(cat "testdemos/${demos[i]}.params")
    echo -e "\e[1m[$((i + 1))/${#demos[@]}] \e[1;36m${descs[i]} testing...\e[0m"
    echo -e "    - \e[0;33mParameters $params\e[0m"
    wine hlds.exe --rehlds-enable-all-hooks --rehlds-test-play "testdemos/${demos[i]}.bin" $params &> result.log || retVal=$?
    
    if [ $retVal -ne 777 ] && [ $retVal -ne 9 ]; then
        # Print with catchy messages
        while read line; do
            echo -e "      \e[0;33m$line"
        done <<< $(cat result.log | sed '0,/demo failed/I!d;/wine:/d;/./,$!d')
        echo "      🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸"
        
        while read line; do
            echo -e "      \e[1;31m$line";
        done < rehlds_demo_error.txt
        
        echo -e "      \e[30;41mExit code: $retVal\e[0m"
        echo -e "\e[1m[$((i + 1))/${#demos[@]}] \e[1;36m${descs[i]} testing...\e[1;31m Failed ❌"
        exit 6 # Test demo failed
    else
        # Print result HLDS console
        while read line; do
            echo -e "      \e[0;33m$line"
        done <<< $(cat result.log | sed '/wine:/d;/./,$!d')
        
        echo -e "      \e[30;43mExit code: $retVal\e[0m"
        echo -e "\e[1m[$((i + 1))/${#demos[@]}] \e[1;36m${descs[i]} testing...\e[1;32m Succeed ✔"
    fi
done
