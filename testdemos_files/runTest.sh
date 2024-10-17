#!/bin/bash

params=$(cat "testdemos/${demo}.params")
                    
echo -e "\e[1;36m${desc} testing...\e[0m"
echo -e "    - \e[0;33mParameters: $params\e[0m"

retVal=0
wine hlds.exe --rehlds-enable-all-hooks --rehlds-test-play "testdemos/${demo}.bin" $params &> result.log || retVal=$?
if [ $retVal -ne 777 ] && [ $retVal -ne 9 ]; then
    echo -e "      🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸"
    
    if [ -f rehlds_demo_error.txt ]; then
        while read line; do
            echo -e "      \e[1;31m$line";
        done < rehlds_demo_error.txt
    else
        echo -e "      \e[1;33mrehlds_demo_error.txt not found, dumping result.log:\e[0m"
        cat result.log
    fi
    echo -e "      \e[30;41mExit code: $retVal\e[0m"
    echo -e "\e[1;36m${desc} testing...\e[1;31m Failed ❌\e[0m"
    exit 6 # Test demo failed
else
    while read line; do
        echo -e "      \e[0;33m$line"
    done <<< $(cat result.log | sed '/wine:/d;/./,$!d')
    echo -e "      \e[30;43mExit code: $retVal\e[0m"
    echo -e "\e[1;36m${desc} testing...\e[1;32m Succeed ✔\e[0m"
fi
