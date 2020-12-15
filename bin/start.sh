#!/bin/bash

MODE=$1;  shift
if test "x${MODE}" = "x"
then
    echo "usage $0 {app|minion}"
    exit 1;
fi

function start_minion() (
    source conf/.env
    # MOJO_HOME
    # MOJO_MODE/PLACK_ENV
    ## ./myapp.pl minion worker -m production -I 15 -C 5 -R 3600 -j 10
    cd ${APP_ROOT} && script/${APP_NAME} minion worker -m development
)

function start_app() (
    source conf/.env
    # MOJO_HOME
    # MOJO_LISTEN
    # MOJO_MODE/PLACK_ENV
    ## ./myapp.pl daemon -m production -l http://*:8080
    cd ${APP_ROOT} && script/${APP_NAME} daemon -m development -l http://localhost:3000
)

case ${MODE} in
    app)
        start_app
        ;;
    minion)
        start_minion
        ;;
    *)
        echo "usage $0 {app|minion}"
        exit 1;
esac
