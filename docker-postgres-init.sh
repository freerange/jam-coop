#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
    CREATE USER "$CURRENT_USER" SUPERUSER;
EOSQL
