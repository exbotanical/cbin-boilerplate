#!/usr/bin/env sh

docker container ls -a | grep <project> | awk '{ print $1 }' | xargs docker rm
docker image ls | grep <project> | awk '{ print $3 }' | xargs docker rmi
docker build -f Dockerfile.dev -t <project> .
docker run -it --entrypoint /bin/bash -v $(pwd):/usr/app <project>
