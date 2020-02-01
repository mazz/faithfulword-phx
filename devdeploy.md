# deploy dev to prod

## dev environment:

### latest db fie:
2019-11-10-mediaitem-v1.3-bin.sql

FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev ./dbtool.py migratefromwebsauna ./2019-11-10-mediaitem-v1.3-bin.sql faithful_word_dev ; ./dbtool.py convertv12bibletoplaylists faithful_word_dev ; ./dbtool.py convertv12gospeltoplaylists faithful_word_dev ; ./dbtool.py convertv12musictoplaylists faithful_word_dev ; ./dbtool.py normalizemusic faithful_word_dev ; ./dbtool.py normalizegospel faithful_word_dev ; ./dbtool.py normalizepreaching faithful_word_dev ; ./dbtool.py normalizebible faithful_word_dev ; ./dbtool.py misccleanup faithful_word_dev ; FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix run apps/db/priv/repo/seeds.exs ; FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix run apps/db/priv/repo/hash_ids.exs

## export db as a complete seeded file to production:
./dbtool.py exportdb faithful_word_dev /Applications/Postgres.app/Contents/Versions/12/bin 2020-01-24-media-item-bin-v1.3-seeded-mat.sql 
Password: rose00budd

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
