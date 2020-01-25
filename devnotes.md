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

# deploy dev to prod

## dev environment:

### latest db file:
2019-11-10-mediaitem-v1.3-bin.sql


## linux local postgresql

sudo vim /etc/postgresql/10/main/pg_hba.conf

```
local   all             postgres                                trust
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
```

### create postgres/postgres
```
sudo -u postgres psql
```
psql:
```
postgres=# ALTER USER postgres PASSWORD 'postgres';
postgres=# CREATE ROLE michael WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD 'michael';
postgres=# CREATE ROLE faithful_word WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD 'faithful_word';
postgres=# create database michael;
```


```
FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev ./dbtool.py migratefromwebsauna ./2019-11-10-mediaitem-v1.3-bin.sql faithful_word_dev /Applications/Postgres.app/Contents/Versions/12/bin ; ./dbtool.py convertv12bibletoplaylists faithful_word_dev ; ./dbtool.py convertv12gospeltoplaylists faithful_word_dev ; ./dbtool.py convertv12musictoplaylists faithful_word_dev ; ./dbtool.py normalizemusic faithful_word_dev ; ./dbtool.py normalizegospel faithful_word_dev ; ./dbtool.py normalizepreaching faithful_word_dev ; ./dbtool.py normalizebible faithful_word_dev ; ./dbtool.py misccleanup faithful_word_dev ; FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix run apps/db/priv/repo/seeds.exs ; FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix run apps/db/priv/repo/hash_ids.exs
```

## export db as a complete seeded file to production:
```
./dbtool.py exportdb faithful_word_dev /Applications/Postgres.app/Contents/Versions/12/bin 2019-11-10-media-item-seeded-not-materialized.pgsql
```

<commit 2019-11-10-media-item-seeded-not-materialized.pgsql>
<commit 2019-11-10-media-item-v1.3-bin.pgsql>
<push to origin/develop>

## prod environment:

ssh root@157.230.171.172 (api.faithfulword.app)

cd faithfulword-phx

git checkout develop
git pull

docker-compose pull
docker-compose build --pull faithful_word

docker-compose up --build -d postgres

docker cp ./2019-11-10-media-item-seeded-not-materialized.pgsql faithfulword-phx_postgres_1:/2019-11-10-media-item-seeded-not-materialized.pgsql

docker exec -ti faithfulword-phx_postgres_1 bash
docker exec -ti faithfulword-phx_faithful_word_1 bash

psql -U postgres
<!-- drop database faithful_word;
create database faithful_word; -->
SET session_replication_role = replica;
\q

pg_restore -U postgres --clean --dbname=faithful_word 2019-11-10-media-item-seeded-not-materialized.pgsql
psql -U postgres
SET session_replication_role = DEFAULT;
refresh materialized view media_items_search;
exit

docker-compose run --rm faithful_word seed
docker-compose run --rm faithful_word generate_hash_ids

# Booting the application in Docker-Compose

docker-compose up --build faithful_word
OR
docker-compose down && docker-compose up -d --force-recreate --build faithful_word

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

# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)

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

./dbtool.py migratefromwebsauna ./2019-11-10-media-item-v1.3-bin.pgsql faithful_word_dev ; ./dbtool.py convertv12bibletoplaylists faithful_word_dev ; ./dbtool.py convertv12gospeltoplaylists faithful_word_dev ; ./dbtool.py convertv12musictoplaylists faithful_word_dev ; ./dbtool.py normalizemusic faithful_word_dev ; ./dbtool.py normalizegospel faithful_word_dev ; ./dbtool.py normalizepreaching faithful_word_dev ; ./dbtool.py normalizebible faithful_word_dev ; ./dbtool.py misccleanup faithful_word_dev ; mix run apps/db/priv/repo/seeds.exs ; mix run apps/db/priv/repo/hash_ids.exs


## design notes

channels can contain playlists and channels
playlists can only contain mediaitems

n = Pigeon.FCM.Notification.new("c8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj", msg)

n = Pigeon.FCM.Notification.new("8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj", notification, data)

## rich notifications
{
  "to" : "devicekey OR /topics/sometopic",
  "mutable_content": true,
  "data": {
    "mymediavideo": "https://myserver.com/myvideo.mp4"
  },
  "notification": {
    "title": "my title",
    "subtitle": "my subtitle",
    "body": "some body"
  }
}

 msg = %{ "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true, "data" => %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}, "notification" => %{ "title" => "push note title", "subtitle" => "push note subtitle", "body" => "push note body" } }

  msg = %{ "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true }

msg = %{ "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true, "data" => %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"} }

 msg = %{ "data" => %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}, "to" => "/fwbcapp/mediaitem/playlist/23-23-423-42-34234", "mutable_content" => true, "title" => "push note title", "subtitle" => "push note subtitle", "body" => "push note body" }


  notification = %{"body" => "your message"}
  data = %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}
  Pigeon.FCM.Notification.new("registration ID", notification, data)



  n = Pigeon.FCM.Notification.new("dcu92ujVPf4:APA91bEaZOL75G1-zWWFGjkNM_l5QW17lmi27veyILTLz7eNeU2hwLNv_17_9Hx_GU8FUWtC82IAGNT8ibqsPGbPH9zOD7N7oRg8seaeDOY3v23pMuuo5wyvuApdEaBFIV3rek4L3c8t", notification, data)

notification = %{"body" => "your message"}
data = %{ "mediaitem" => "uuid-of-media-item", "resource-type" => "uuid"}
n = Pigeon.FCM.Notification.new("c8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj", notification, data)

notification = %{"body" => "your message"}




notification = %{"title" => "New Content", "body" => "Clint Anderson Sings Psalm 81"}
data = %{ "deeplink" => "https://site/m/j4X8", "media_item_uuid" => "82d66cbb-ae6a-4b4e-bbf5-39ee2bb4fc0e", "image_thumbnail_path" => "fwbcapp/thumbs/lg/0005-0026-Psalm81-en.jpg", "image_thumbnail_url" => "https://i.ytimg.com/vi/zPNyuv3fw_4/hqdefault.jpg", "version" => "1.3"}


"mutable-content": 1,
      "content-available": 1,


 ["c8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj"] |> Pigeon.FCM.Notification.new()  |> Pigeon.FCM.Notification.put_mutable_content(true) |> Pigeon.FCM.Notification.put_data(%{ "deeplink" => "https://site/m/j4X8", "media_item_uuid" => "82d66cbb-ae6a-4b4e-bbf5-39ee2bb4fc0e", "image_thumbnail_path" => "fwbcapp/thumbs/lg/0005-0026-Psalm81-en.jpg", "image_thumbnail_url" => "https://i.ytimg.com/vi/zPNyuv3fw_4/hqdefault.jpg", "mutable-content" => true, "version" => "1.3"}) |> Pigeon.FCM.push()


piping and WORKS:

 ["c8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj"] |> Pigeon.FCM.Notification.new() |> Pigeon.FCM.Notification.put_notification(%{"body" => "your message"}) |> Pigeon.FCM.push() 

piping and mutable_content WORKS:

 ["c8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj"] |> Pigeon.FCM.Notification.new() |> Pigeon.FCM.Notification.put_notification(%{"body" => "your message"}) |> Pigeon.FCM.Notification.put_mutable_content(true) |> Pigeon.FCM.push()

piping and mutable_content and data WORKS:

 ["c8xGnjc9b74:APA91bH98ndvTkjHUiF7J3tUcM620WwUcgqImGFSEN7Uw5vXGReJzlu_IkcaDgDpWJRlTyWY836aMN9ujU8bPu5EQnqncsOiovWA_6ww6xbPo9HYuUKXLfyDQ_qc8M3Zzbm9nkTSP6mj"] |> Pigeon.FCM.Notification.new() |> Pigeon.FCM.Notification.put_notification(%{"body" => "your message"}) |> Pigeon.FCM.Notification.put_data(%{ "deeplink" => "https://site/m/j4X8", "entity_type" => "mediaitem", "entity_uuid" => "82d66cbb-ae6a-4b4e-bbf5-39ee2bb4fc0e", "org" => "fwbcapp", "image_thumbnail_path" => "thumbs/lg/0005-0026-Psalm81-en.jpg", "image_thumbnail_url" => "https://i.ytimg.com/vi/zPNyuv3fw_4/hqdefault.jpg", "mutable-content" => true, "version" => "1.3"}) |> Pigeon.FCM.Notification.put_mutable_content(true) |> Pigeon.FCM.push() 


