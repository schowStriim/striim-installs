#!/bin/bash
################################################################################################
# Script name: striim_error_log_finder.sh                                                      #
# Description: This shell script will extract ALL errors from the striim.server.log file OR    #
#              from a specific application component.                                          #
# Usage: sudo ./striim_error_log_finder.sh /opt/striim/logs/striim.server.log <component_name> # 
################################################################################################

GREEN=$'\e[0;32m'
BLUE=$'\e[0;34m'
RED=$'\e[0;31m'
NC=$'\e[0m'

LOG_FILE=$1
APP_COMPONENT_NAME=$2

if [[ -z "$LOG_FILE" ]] ;
then
    
    printf "\n${RED}ERROR: Missing the log directory path. Please enter the directory path of the striim.server.logs${NC} \n"
    printf "${RED}For example: ./striim_error_log_finder.sh /opt/custom/path/dir/logs/ ${NC}\n"
    exit 1
fi

if [[ -f "$LOG_FILE" ]]; then
    
    TIMESTAMP=$(date +%s)
    
    if [[ ! -z "$APP_COMPONENT_NAME" ]] ; then
        ERROR_LOG_FILE="$APP_COMPONENT_NAME"_striim_error_logs_"$TIMESTAMP".log
        grep -e "-ERROR" $LOG_FILE | grep -e $APP_COMPONENT_NAME | awk '{print $0,"\n"}' > $ERROR_LOG_FILE
        printf "${GREEN}Successfully parsed and generated the $APP_COMPONENT_NAME Striim error log file: $ERROR_LOG_FILE ${NC}\n "
    else
        ERROR_LOG_FILE=striim_error_logs_"$TIMESTAMP".log
        printf "\n${BLUE}This execution will parse and generate all the ERROR messages from the striim.server.log ${NC}\n"
        printf "${BLUE}If you want to print error logs of a specific application, enter the app name in the second argument when executing the script. ${NC}\n"
        printf "${BLUE}For example: ./striim_error_log_finder.sh /opt/striim/custom/path admin.APP_COMPONENT_NAME ${NC}\n\n"
        grep -e "-ERROR" $LOG_FILE | awk '{print $0,"\n"}' > $ERROR_LOG_FILE
        printf "${GREEN}Successfully parsed and generated the Striim error log file: $ERROR_LOG_FILE ${NC}\n "
    fi
    
else
    printf "\n ${RED}The striim.server.log file doesn't exist in the specified directory: $LOG_FILE ${NC}\n"
    exit 1
fi
