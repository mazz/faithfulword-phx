# rename elixir project

git grep -l 'old_name' | xargs sed -i '' -e 's/old_name/new_name/g'
git grep -l 'OldName' | xargs sed -i '' -e 's/OldName/NewName/g'
mv ./lib/old_name ./lib/new_name
mv ./lib/old_name.ex ./lib/new_name.ex
If you have a similar folder structure in the tests folder, you probably also need:
mv ./test/old_name ./test/new_name
mv ./lib/old_name_web ./lib/new_name_web
mv ./lib/old_name_web.ex ./lib/new_name_web.ex

# docker logs
docker logs <container-id>

https://www.shanesveller.com/blog/2018/11/13/kubernetes-native-phoenix-apps-part-2/

docker-compose pull
docker-compose build --pull faithful_word 
## OR build and restart faithful_word only -- use IFF there was no db schema change!
docker-compose up --detach --build faithful_word 

docker-compose up --build -d postgres
docker-compose run --rm faithful_word migrate

docker cp ./2019-01-27-plurals-10-bin.sql add-12-api_postgres_1:/2019-01-27-plurals-10-bin.sql
docker exec -ti add-12-api_postgres_1 bash

psql -U faithful_word
<!-- drop database faithful_word;
create database faithful_word; -->
SET session_replication_role = replica;
\q

pg_restore -U faithful_word --clean --dbname=faithful_word 2019-01-27-plurals-10-bin.sql
psql -U faithful_word
SET session_replication_role = DEFAULT;
exit

docker-compose run --rm faithful_word seed

Booting the application in Docker-Compose

docker-compose up --build faithful_word

You can then browse the application by visiting http://localhost:4000 as normal, and should see the typical (production-style) log output in the shell session that’s running the above docker-compose command.

Note that this running container will not pick up any new file changes, perform live-reload behavior, and is generally not useful for development purposes. It’s primary value is ensuring that your release is properly configured via Distillery, and that your Dockerfile remains viable.
Cleaning Up

If you’d like to reset the database, or otherwise clean up after the Docker-Compose environment, you can use the down subcommand, optionally including a flag to clear the data volume as well. Without the flag, it will still remove the containers and Docker-specific network that was created for you.

`docker-compose down --volume`

## docker cleanup
docker ps -a
docker rmi 
docker image ls
docker rm 

## use psql

docker exec -ti faithfulword-phx_postgres_1 psql -p 5432 -U faithful_word

## restore database

docker exec -ti faithfulword-phx_postgres_1 psql -p 5432 -U faithful_word

drop database faithful_word;
create database faithful_word;
SET session_replication_role = replica;
\q
docker exec -i faithfulword-phx_postgres_1 psql -p 5432 -U faithful_word < 2018-11-18-fw-saved-1.3-base.pgsql
docker exec -ti faithfulword-phx_postgres_1 psql -p 5432 -U faithful_word
SET session_replication_role = DEFAULT;

docker exec -ti add-12-api_postgres_1 psql -p 5432 -U faithful_word

## export normalized db

/Applications/Postgres.app/Contents/Versions/11/bin/pg_dump -U postgres --no-owner --no-acl -W -Fc -C -d faithful_word_dev > 2019-02-22-add-v12-api-bin-export.sql

tar -czvf 2019-02-22-add-v12-api-bin-export.sql.gz 2019-02-22-add-v12-api-bin-export.sql

## docker migrate works:

docker cp ./2019-01-27-plurals-10-bin.sql add-12-api_postgres_1:/2019-01-27-plurals-10-bin.sql
docker exec -ti add-12-api_postgres_1 bash
docker exec -ti add-12-api_faithful_word_1 bash
psql -U faithful_word
drop database faithful_word;
create database faithful_word;
SET session_replication_role = replica;
\q

pg_restore -U faithful_word --clean --dbname=faithful_word 2019-01-27-plurals-10-bin.sql
psql -U faithful_word
SET session_replication_role = DEFAULT;


## loader.io
Target Verification: faithfulword.app

    Verify over HTTP

Place this verification token in a file:

loaderio-aceec519d8ce807bcc175e37c2731776

Upload the file to your server so it is accessible at one of the following URLs:

    http://faithfulword.app/loaderio-aceec519d8ce807bcc175e37c2731776/
    http://faithfulword.app/loaderio-aceec519d8ce807bcc175e37c2731776.html
    http://faithfulword.app/loaderio-aceec519d8ce807bcc175e37c2731776.txt


mix deps.get ; mix deps.compile
mix ecto.drop; mix ecto.create ; mix ecto.migrate
mix run apps/db/priv/repo/seeds.exs

git clone https://github.com/FaithfulAudio/faithfulword-phx.git -b upload-ui upload-ui

# export binary db file

"/Applications/Postgres.app/Contents/Versions/11/bin/pg_dump" -U postgres --no-owner --no-acl -W -Fc -C -d kjvrvg_dev > 2019-01-22-media-item-1.3-base-bin.sql

# import 1.3 database

./dbimport.py migratefromwebsauna ./2019-04-02-media-item-bin.pgsql faithful_word_dev ; ./dbimport.py convertv12bibletoplaylists faithful_word_dev ; ./dbimport.py convertv12gospeltoplaylists faithful_word_dev ; ./dbimport.py convertv12musictoplaylists faithful_word_dev ; ./dbimport.py normalizemusic faithful_word_dev ; ./dbimport.py normalizegospel faithful_word_dev ; ./dbimport.py normalizepreaching faithful_word_dev ; ./dbimport.py normalizebible faithful_word_dev ; mix run apps/db/priv/repo/seeds.exs
