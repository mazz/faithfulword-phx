The devnotes.md has some commands to get your environment up but you'll need asdf:

### go to this page and follow how to install asdf:

https://asdf-vm.com/#/core-manage-asdf-vm

then:
```
asdf plugin-add elixir
asdf plugin-add erlang
asdf plugin-add nodejs

asdf install elixir 1.9.1
asdf install erlang 22.0.7
NODEJS_CHECK_SIGNATURES=no asdf install nodejs 11.15.0
```

### install a local postgresql db server
mac: go to https://postgresapp.com and download latest binary
linux ubuntu: install psql

### now you're ready to install the web app:

```
cd ~/faithfulword-phx
git fetch
git checkout develop # latest working branch
mix deps.get && mix deps.compile
cd apps/faithful_word_api
cd assets && npm install
cd ../../
python3 -m venv my3venv
source my3venv/bin/activate
pip install -U pip
pip install psycopg2
cd ../faithfulword-phx

### latest db file:
2019-11-10-mediaitem-v1.3-bin.sql


## linux local postgresql

sudo vim /etc/postgresql/10/main/pg_hba.conf
```
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
postgres=# create database michael;
```

```
FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev ./dbtool.py migratefromwebsauna ./2019-11-10-mediaitem-v1.3-bin.sql faithful_word_dev /usr/bin ; ./dbtool.py convertv12bibletoplaylists faithful_word_dev ; ./dbtool.py convertv12gospeltoplaylists faithful_word_dev ; ./dbtool.py convertv12musictoplaylists faithful_word_dev ; ./dbtool.py normalizemusic faithful_word_dev ; ./dbtool.py normalizegospel faithful_word_dev ; ./dbtool.py normalizepreaching faithful_word_dev ; ./dbtool.py normalizebible faithful_word_dev ; ./dbtool.py misccleanup faithful_word_dev ; FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix run apps/db/priv/repo/seeds.exs ; FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix run apps/db/priv/repo/hash_ids.exs
```
### export db as a complete seeded file to production:
```
./dbtool.py exportdb faithful_word_dev /usr/bin 2019-11-10-media-item-seeded-not-materialized.pgsql
```
### run
FW_DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word_dev mix phx.server
```

### open url in browser
```
http://localhost:4000/v1.2/books?language-id=en

```
currently we manually refresh the ts_vector index because the PG triggers slow down the dbtool.py import script.
If you want /v1.3/search to return results you must run this SQL statement:

refresh materialized view media_items_search

```

