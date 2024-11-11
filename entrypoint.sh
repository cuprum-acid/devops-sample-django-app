#!/bin/bash

# Function to wait for database to be ready
wait_for_db() {
    until python3 -c "
import psycopg2
from psycopg2 import OperationalError
try:
    conn = psycopg2.connect(
        dbname='$DJANGO_DB_NAME',
        user='$DJANGO_DB_USER',
        password='$DJANGO_DB_PASS',
        host='$DJANGO_DB_HOST',
        port='$DJANGO_DB_PORT'
    )
    conn.close()
except OperationalError:
    exit(1)
" 
    do
        echo "Waiting for database..."
        sleep 5
    done
}

# Run database migration and start the server
wait_for_db
echo "Database is ready. Running migrations..."
python3 manage.py migrate
exec "$@"
