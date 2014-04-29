#!/bin/sh
#
# initdb --encoding=UTF8 --no-local -D $DB_PATH
#
# listen_addresses = 'localhost'      # what IP address(es) to listen on;
# port = 5432             # (change requires restart)
# unix_socket_directory = '/tmp/'     # (change requires restart)
#
#
# createdb hasegawa -h localhost 
#
# psql -h localhost


DB_PATH=`pwd`/data
CMD=/usr/local/bin/pg_ctl

case "$1" in
    start)
      $CMD start -D $DB_PATH
        ;;
    stop)
      $CMD stop -D $DB_PATH -m fast #immediate
        ;;
    status)
      $CMD status -D $DB_PATH 
        ;;
    *)
        echo "Usage: $0 {start|stop|status} "
        exit 1
        ;;
esac

exit 0

