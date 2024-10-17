#!/bin/bash

CYAN="\e[1;36m"
YELLOW="\e[0;33m"
RED="\e[1;31m"
BOLD_RED="\e[30;41m"
BOLD_YELLOW="\e[30;43m"
RESET="\e[0m"

ERROR_FILE="rehlds_demo_error.txt"
RESULT_FILE="result.log"

params=$(cat "testdemos/${demo}.params")

printf "${CYAN}%s testing...${RESET}\n" "${desc}"
printf "    - ${YELLOW}Parameters: %s${RESET}\n" "$params"

retVal=0
wine hlds.exe --rehlds-enable-all-hooks --rehlds-test-play "testdemos/${demo}.bin" $params &> "$RESULT_FILE" || retVal=$?

if [ $retVal -eq 777 ] || [ $retVal -eq 9 ]; then
    while IFS= read -r line; do
        printf "      ${YELLOW}%s${RESET}\n" "$line"
    done <<< $(sed '/wine:/d;/./,$!d' "$RESULT_FILE")

    printf "      ${BOLD_YELLOW}Exit code: %d${RESET}\n" "$retVal"
    printf "${CYAN}%s testing...${YELLOW} Succeed ✔${RESET}\n" "$desc"
    exit 0
fi

printf "      🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸  🔸\n"

if [ -f "$ERROR_FILE" ]; then
    while IFS= read -r line; do
        printf "      ${RED}%s${RESET}\n" "$line"
    done < "$ERROR_FILE"
else
    printf "      ${YELLOW}rehlds_demo_error.txt not found, dumping result.log:${RESET}\n"
    cat "$RESULT_FILE"
fi

printf "      ${BOLD_RED}Exit code: %d${RESET}\n" "$retVal"
printf "${CYAN}%s testing...${RED} Failed ❌${RESET}\n" "$desc"
exit 1
