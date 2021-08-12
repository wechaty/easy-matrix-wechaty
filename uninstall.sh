#!/usr/bin/env bash
echo 'Stoping server...' 
docker-compose down 
echo 'Stopped successfully!'

echo 'Clearing data.'
docker-compose run --rm --entrypoint sh synapse -c "rm -rf /data/*" &&
rmdir ./files/ &&
echo 'Cleared successfully!'