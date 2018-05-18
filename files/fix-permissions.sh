#!/bin/sh
chown user:user /src /build
exec su -c "$*" user
