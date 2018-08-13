#!/bin/sh
set -e
set -x

if [ -z $1 ]; then
    COSBENCH_MANTA_PATH=$(find target -name 'cosbench-manta-*.jar' -print -quit)
    COSBENCH_MANTA_CHECKSUM=$(shasum -a256 $COSBENCH_MANTA_PATH | cut -d' ' -f1)
else
    COSBENCH_MANTA_PATH=$1
    COSBENCH_MANTA_CHECKSUM=$2
fi

if [ -z $COSBENCH_MANTA_PATH ]; then
	>&2 echo "No cosbench-manta jar found, expecting a file named 'cosbench-manta-*.jar' in 'target' subdirectory"
	exit 1
fi

if [ -z $COSBENCH_MANTA_CHECKSUM ]; then
	>&2 echo "Missing SHA256 checksum"
	exit 1
fi

COSBENCH_IMAGE_TAG=${COSBENCH_IMAGE_TAG:-latest}
COSBENCH_DOCKERFILE=${COSBENCH_DOCKERFILE:-Dockerfile}

docker build \
    --build-arg COSBENCH_MANTA_PATH=$COSBENCH_MANTA_PATH \
    --build-arg COSBENCH_MANTA_CHECKSUM=$COSBENCH_MANTA_CHECKSUM \
    --tag joyent/cosbench-manta:$COSBENCH_IMAGE_TAG \
    --file $COSBENCH_DOCKERFILE \
    .
