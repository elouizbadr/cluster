#!/bin/bash
set -e

docker run -d -p 3306:3306 -p 8080:8080 --name my-running-haproxy my-haproxy
