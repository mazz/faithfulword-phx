#!/bin/bash
# Docker entrypoint

# Wait until database is ready (requires postgres-client)
while ! pg_isready -q -h $FW_DATABASE_HOSTNAME -p $FW_DATABASE_PORT -U $FW_DATABASE_USERNAME
do
    echo "waiting for database to start"
    sleep 2
done
# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $FW_DATABASE_NAME"` ]]; then
    echo "Database $FW_DATABASE_NAME does not exist. Creating..."
    createdb -E UTF8 $FW_DATABASE_NAME -l en_US.UTF-8 -T template0

    ############################################################
    # Put here the commands to initialize the database:
    # psql run_a_script
    # python run_a_script (this scripts must be copied here (Dockerfile), maybe in the /opt/app/scripts/ path)


    # Put here the commands to migrate and seed the database:
    # /opt/app/bin/start_server eval "DB.ReleaseTasks.migrate(args)"
    # /opt/app/bin/start_server eval "DB.ReleaseTasks.seed(args)"
    ############################################################

    echo "Database $FW_DATABASE_NAME created."
fi

# start server # (original name was changed in Dockefile)
/opt/app/bin/start_server start
