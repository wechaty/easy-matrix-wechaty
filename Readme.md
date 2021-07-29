# Easy `matrix-appservice-wechaty`

This is a simple and fast temporary deployment solution that provides a way to experience the main functions of [matrix-appservice-wechaty](https://github.com/wechaty/matrix-appservice-wechat). After some simple steps you can deploy a synapse server and a matrix-appservice-wechaty server. At present, in order to have a better experience, we need a domain name and a computer with a public IP address. Fortunately, we are designing a full-featured deployment plan for unpublic IP and domain names, and it is expected to be released this year(If it's necessary. ^_^).

---

## Environment

(other version is supported)
```text
Centos 7 (linux or mac is enough)
Docker version 20.10.7 https://docs.docker.com/engine/install/
docker-compose version 1.7.0 https://docs.docker.com/compose/install/
```

## Configuration and Deployment(you can run without any modify)

```shell
# prepare a work directory
git clone https://github.com/545641826/easy-matrix-wechaty
cd ./easy-matrix-wechaty

# prepare environment variables.
# You will need to specify appropriate values for follow variables:
export HOST=localhost.localdomain4 # your domain name. See: <https://matrix-org.github.io/synapse/latest/federate.html> SYNAPSE_SERVER_NAME
export SYNAPSE_USER_NAME=test
export SYNAPSE_USER_PASSWD=passwd

# generate the config file of Synapse. ref:<https://github.com/matrix-org/synapse/blob/develop/docker/README.md#generating-a-configuration-file>
docker-compose run --rm -e SYNAPSE_SERVER_NAME=$HOST -e SYNAPSE_REPORT_STATS=yes synapse generate

# prepare matrix-appservice-wechaty config file
sudo sh -c "echo \"domain: $HOST
homeserverUrl: http://$HOST:8008
registration: wechaty-registration.yaml\" > ./files/wechaty-config.yaml"

# generate the config file of matrix bridge.
docker-compose run --rm matrix-appservice-wechaty --config /data/wechaty-config.yaml --url http://matrix-appservice-wechaty:8788 --generate-registration

# add wechaty-registration.yaml to homeserver.yaml
sudo sed -e 's/#app_service_config_files/app_service_config_files/' -e '/app_service_config_files/a\  - \/data\/wechaty-registration.yaml' -i files/homeserver.yaml

# run server
docker-compose -f "synapse-wechaty/docker-compose.yml" up -d

# create a synapse user
docker-compose exec synapse register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml -u $SYNAPSE_USER_NAME -p $SYNAPSE_USER_PASSWD --no-admin
```

## Usage

1. Visit [your matrix homepage](http://localhost:8008/_matrix/static/) to check if matrix is runing.
2. Open any [Matrix client](https://matrix.org/docs/projects/try-matrix-now.html#clients),and to login with the homeserver(http://localhost:8008) and the user/password(test/passwd).
3. Add @wechaty:localhost and talk anythink to it, it will guide you to start the bridge.

## Other
stop server: docker-compose down