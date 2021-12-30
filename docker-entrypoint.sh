#!/bin/bash

wait_seconds=1
iterations=0
while true
do
    nc -z "${TTRSS_DB_HOST}" "${TTRSS_DB_PORT}" > /dev/null 2>&1
    # nc -z "${TTRSS_DB_HOST}" 1234 > /dev/null 2>&1
    if [ $? -eq 0 ];
    then
        break
    fi

    if [ ${iterations} -gt 10 ];
    then
        echo "Timeout waiting for database ${TTRSS_DB_HOST}:${TTRSS_DB_PORT}, exiting."
        exit 1
    fi

	((iterations++))
	sleep $wait_seconds
done

echo "performing schema update .."
sudo -E -u nobody php /var/www/update.php --update-schema=force-yes

exec "$@"
