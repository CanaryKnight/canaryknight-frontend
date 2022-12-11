#!/bin/sh

set -e

rm -rf dist && mkdir -p dist

rm -rf node_modules && CYPRESS_CACHE_FOLDER=.cache/cypress YARN_CACHE_FOLDER=.cache/yarn yarn install

chgrp -R $GID node_modules
chgrp -R $GID  dist

yarn run dev