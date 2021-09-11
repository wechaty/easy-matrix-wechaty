#!/usr/bin/env sh

chmod 0755 *.sh

# prepare environment variables.
# You will need to specify appropriate values for follow variables:
export HOST=localhost # your domain name. See: <https://matrix-org.github.io/synapse/latest/federate.html> SYNAPSE_SERVER_NAME
export SYNAPSE_USER_NAME=test
export SYNAPSE_USER_PASSWD=passwd
mkdir -p ./data/synapse ./data/wechaty


# generate the config file of Synapse. ref:<https://github.com/matrix-org/synapse/blob/develop/docker/README.md#generating-a-configuration-file>
docker-compose run --rm -e SYNAPSE_SERVER_NAME=$HOST -e SYNAPSE_REPORT_STATS=yes synapse generate

# prepare matrix-appservice-wechaty config file
# sudo sh -c "echo \"domain: $HOST
# homeserverUrl: http://synapse:8008
# registration: wechaty-registration.yaml\" > ./files/wechaty-config.yaml"
docker-compose run --rm --entrypoint sh matrix-appservice-wechaty -c "echo \"domain: $HOST
homeserverUrl: http://synapse:8008
registration: wechaty-registration.yaml\" > /data/wechaty-config.yaml"

# generate the config file of matrix bridge.
docker-compose run --rm matrix-appservice-wechaty --config /data/wechaty-config.yaml --url http://matrix-appservice-wechaty:8788 --generate-registration

# add wechaty-registration.yaml to homeserver.yaml
# sudo sed -e 's/#app_service_config_files/app_service_config_files/' -e '/app_service_config_files/a\  - \/wechaty-registration.yaml' -i files/homeserver.yaml
docker-compose run --rm --entrypoint sed synapse -e 's/#app_service_config_files/app_service_config_files/' -e '/app_service_config_files/a\  - \/wechaty\/wechaty-registration.yaml' -i /data/homeserver.yaml

# run server
docker-compose -f "docker-compose.yml" up -d

# create a synapse user
docker-compose exec synapse register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml -u $SYNAPSE_USER_NAME -p $SYNAPSE_USER_PASSWD --no-admin

# docker-compose restart synapse # Avoid get no response when talking to @wechaty:localhost.(the bridge not work)

docker-compose down