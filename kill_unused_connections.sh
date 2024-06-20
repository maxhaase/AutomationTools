#!/bin/bash
# Author: Max Haase - maxhaase@gmail.com
##############################################################################################
# Closes unused connections, in this case 8080, but you can easily change that to something else.
# Save it, make it executable and run it as root or sudo.
##############################################################################################

# Get all established connections on port 8088
CONNS=$(netstat -anp | grep :8088 | grep EST | awk '{print $7}' | cut -d'/' -f1)

for PID in $CONNS; do
    # Check if the process is running
    if ! ps -p $PID > /dev/null; then
        # Find the connection details
        CONN_DETAILS=$(ss -K | grep $PID)
        if [ -n "$CONN_DETAILS" ]; then
            echo "Closing orphaned connection for PID $PID:"
            echo "$CONN_DETAILS"

            # Extract local and remote addresses and ports
            LOCAL_ADDR=$(echo $CONN_DETAILS | awk '{print $5}' | cut -d':' -f1,2)
            REMOTE_ADDR=$(echo $CONN_DETAILS | awk '{print $6}' | cut -d':' -f1,2)

            # Use ss to kill the connection
            ss -K src "$LOCAL_ADDR" dst "$REMOTE_ADDR"
        fi
    fi
done
