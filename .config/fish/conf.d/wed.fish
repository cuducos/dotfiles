if type -q wed
    if [ (uname -o | string lower) = darwin ]
        set -l WED_NOTIFICATION_FILE $HOME/.last_wed_notification
        set -l NOW (date +%s)
        set -l ONE_HOUR 3600

        if [ ! -e $WED_NOTIFICATION_FILE ]
            echo 0 >$WED_NOTIFICATION_FILE
        end

        set -l LAST_WED_NOTIFICATION (cat $WED_NOTIFICATION_FILE)
        if [ $NOW -gt (math $LAST_WED_NOTIFICATION + $ONE_HOUR) ]
            wed notify
            echo $NOW >$WED_NOTIFICATION_FILE
        end
    end
end
