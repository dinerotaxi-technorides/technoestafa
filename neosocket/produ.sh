#!/bin/bash
case "$1" in
        master)
            echo "Starting master"
            sudo su && killall node && nohup make run &
            ;;
         
        slave)
            echo "Starting slave"
            
            sudo su && killall node && nohup make run_slave &
            ;;
         
        cloud)
            echo "Starting slave"
            
            sudo su && killall node && nohup make run_cloud &
            ;;
        stop)
            echo "stop server"
            sudo su && killall node
            ;;
        log)
            echo "log"
            tail -f nohup.out
            ;;
        *)
            echo $"Usage: $0 {master|slave|stop|log}"
            exit 1
 
esac