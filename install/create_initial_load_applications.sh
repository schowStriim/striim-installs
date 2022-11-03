#!/bin/bash

# Create IL application.
echo "Would you like to create Initial Load application(s)? (yes or no)"
read ANSWER

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
JAVA_FILE_DIR="$SCRIPT_DIR"/InitialLoadTQLGenerator_v06.jar

if [ $ANSWER == 'yes' ] || [ $ANSWER == 'y' ] || [ $ANSWER == 'YES' ]
then
    echo "How many Initial Load applications would you like to create?"
    read IL_AMOUNT
    if [ $IL_AMOUNT -eq 1 ]
    then

        java -jar $JAVA_FILE_DIR

    elif [ $IL_AMOUNT -gt 1 ]
    then

        echo -e "\nYou would like to create $IL_AMOUNT Initial Load applications."
        echo "Please note that before you run the $IL_AMOUNT applications, you will have to follow these steps:"
        echo "1) Disable all your constraints in the target database."
        echo "2) Import all $IL_AMOUNT TQL to Striim by logging in to the console -> Create App -> Select Import TQL File"
        echo -e "\nAfter you successfully imported all your applications, follow these steps:"
        echo "1) Deploy and start a single application first."
        echo "2) Consistently Monitor the health/resource utilization by clicking on the Monitor tab and make sure the server is able to handle it."
        echo "3) If everything looks good, deploy and start the remaining applications."
        echo -e "\nWould you still like to proceed? (yes or no)"
        read PROCEED
        
        if [ $PROCEED == 'yes' ]
        then
            java -jar $JAVA_FILE_DIR
        fi
    fi
elif [ $ANSWER == 'no' ] || [ $ANSWER == 'n' ] || [ $ANSWER == 'NO' ]
then
    echo "OK."
else
    echo "Not a valid answer."
fi
