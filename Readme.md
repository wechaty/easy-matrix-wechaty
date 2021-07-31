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

## Configuration and Deployment

Please use the docker user to run the following commands.

```shell
# prepare a work directory
git clone https://github.com/545641826/easy-matrix-wechaty
cd ./easy-matrix-wechaty

# Get the latest docker image of `wechaty/matrix-appservice:latest`.
docker pull wechaty/matrix-appservice:latest

chmod +x ./run.sh # You can modify the environment variables in the script for configuration, but if you can configure it, I don't think you need this script.

./run.sh
```

## Usage

1. Visit [your matrix homepage](http://localhost:8008/_matrix/static/) to check if matrix is runing.
2. Open any [Matrix client](https://matrix.org/docs/projects/try-matrix-now.html#clients),and to login with the homeserver(http://localhost:8008) and the user/password(test/passwd).
3. Add @wechaty:localhost and talk anythink to it, it will guide you to start the bridge.

## Other
stop server: docker-compose down