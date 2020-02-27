#!/bin/sh

set -e

echo "Waiting to ensure everything is fully ready for the tests..."
sleep 60

if ! ping -c 10 -q jenkins ; then
    echo 'Bitnami Jenkins Main container is not responding!'
    # TODO Display logs to help bug fixing
    #echo 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 2
fi

# XXX Add your own tests
# https://docs.docker.com/docker-hub/builds/automated-testing/
#echo "Executing Bitnami Jenkins app tests..."
## TODO Test result of tests

# Success
echo 'Docker tests successful'
exit 0
