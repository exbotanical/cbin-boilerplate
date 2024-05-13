FROM ubuntu:20.04

RUN apt-get update && apt-get install -y git gcc make curl

RUN sh -c "`curl -L https://raw.githubusercontent.com/rylnd/shpec/master/install.sh`"

COPY scripts/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
