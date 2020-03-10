#!/bin/bash
#builds tests and deploys data container from prepared data


# Set these environment variables
#DOCKER_USER // dockerhub credentials
#DOCKER_AUTH
set -e

ROUTER_NAME=${1:-hsl}
DATE=`date +"%Y-%m-%d"`

ORG=${ORG:-hsldevcom}
CONTAINER=opentripplanner-data-container
DOCKER_IMAGE=$ORG/$CONTAINER-$ROUTER_NAME
DOCKER_TEST_IMAGE=$DOCKER_IMAGE:test


echo "*** Testing $ROUTER_NAME..."

./test.sh $ROUTER_NAME $TEST_TAG $TOOLS_TAG

echo "*** $ROUTER_NAME tests passed"

if [ -v DOCKER_TAG ] && [ "$DOCKER_TAG" != "undefined" ]; then
    DOCKER_DATE_IMAGE=$DOCKER_IMAGE:$DATE-$DOCKER_TAG
    DOCKER_CUSTOM_IMAGE_TAG=$DOCKER_IMAGE:$DOCKER_TAG
    docker tag $DOCKER_TEST_IMAGE $DOCKER_DATE_IMAGE
    docker tag $DOCKER_TEST_IMAGE $DOCKER_CUSTOM_IMAGE_TAG
    echo "*** Tagged as $DOCKER_CUSTOM_IMAGE_TAG"
else
    DOCKER_DATE_IMAGE=$DOCKER_IMAGE:$DATE-latest
    DOCKER_LATEST_IMAGE=$DOCKER_IMAGE:latest
    docker tag $DOCKER_TEST_IMAGE $DOCKER_DATE_IMAGE
    echo "*** Pushing $DOCKER_DATE_IMAGE"
    docker tag $DOCKER_TEST_IMAGE $DOCKER_LATEST_IMAGE
    echo "*** Deployed $ROUTER_NAME"
fi
