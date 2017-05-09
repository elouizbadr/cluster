#!/bin/bash

cat >> /etc/services <<<EOL
mysqlchk	9200/tcp		# mysqlchk
EOL
