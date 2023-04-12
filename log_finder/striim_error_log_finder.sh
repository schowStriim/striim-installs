#!/bin/bash
###########################################################################################
# Script name: striim_error_log_finder.sh                                                 #
# Description: This shell script will extract ALL errors from the striim.server.log file. #
# Usage: sudo ./striim_error_log_finder.sh /opt/striim/logs                               #
###########################################################################################

GREEN=$'\e[0;32m'
BLUE=$'\e[0;34m'
RED=$'\e[0;31m'
NC=$'\e[0m'

LOG_DIR=$1

if [[ -z "$LOG_DIR" ]] ;
then
    
    printf "\nERROR: Missing the log directory path. \n"
    printf "Please provide striim.server.log directory path.\n"
    printf "${RED}Example: ./striim_error_log_finder.sh /opt/striim/logs ${NC}\n"
    exit 1
fi

LOG_FILE=$LOG_DIR/striim.server.log

if [[ -f "$LOG_FILE" ]]; then
    
    TIMESTAMP=$(date +%s)
    ERROR_LOG_FILE=$LOG_DIR/striim_error_logs_"$TIMESTAMP".log

    grep -e "-ERROR" $LOG_FILE | awk '{print $0,"\n"}' > $ERROR_LOG_FILE
    printf "Successfully parsed and generated the Striim error log file: $ERROR_LOG_FILE"
else
    printf "\n The striim.server.log file doesn't exist in the specified directory: $LOG_FILE \n"
    exit 1
fi
