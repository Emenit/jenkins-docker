# Jenkins Docker Image

Made by Emenit team.

## Usage

TL;DR

```bash
docker build -t jenkins:latest --build-arg DOCKER_GID=<Docker Group ID> --build-arg JENKINS_ADMIN_USER=<Jenkins admin user name> --build-arg JENKINS_ADMIN_PASSWORD=<Jenkins admin user password> --pull --no-cache .
```

### Docker Group ID

Build requires the docker Group ID on Host machine to use its deamon for further image building.

To get the group ID run the following command:

```bash
getent group | grep docker
```

Output should look something like this:

```bash
docker:x:999:myusername
```

Get only the integer number `999` in this example. When building Jenkins Docker image provide it as a `--build-arg` argument in the command line.
