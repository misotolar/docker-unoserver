#!/bin/sh

set -ex

entrypoint-hooks.sh

fc-cache -fv

entrypoint-post-hooks.sh

exec "$@"