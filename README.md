The devnotes.md has some commands to get your environment up but you'll need asdf:

### go to this page and follow how to install asdf:

https://asdf-vm.com/#/core-manage-asdf-vm

then:
```
asdf plugin-add elixir
asdf plugin-add erlang
asdf plugin-add nodejs

asdf install elixir 1.9.0
asdf install erlang 21.2.3
NODEJS_CHECK_SIGNATURES=no asdf install nodejs 10.16.0
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

./dbtool.py migratefromwebsauna ./2019-06-22-media-item-v1.3-bin.pgsql faithful_word_dev ; ./dbtool.py convertv12bibletoplaylists faithful_word_dev ; ./dbtool.py convertv12gospeltoplaylists faithful_word_dev ; ./dbtool.py convertv12musictoplaylists faithful_word_dev ; ./dbtool.py normalizemusic faithful_word_dev ; ./dbtool.py normalizegospel faithful_word_dev ; ./dbtool.py normalizepreaching faithful_word_dev ; ./dbtool.py normalizebible faithful_word_dev ; ./dbtool.py misccleanup faithful_word_dev ; mix run apps/db/priv/repo/seeds.exs ; mix run apps/db/priv/repo/hash_ids.exs
### run
mix phx.server
```

### open url in browser
http://localhost:4000/v1.2/books?language-id=en

### refresh materialzed view media_items_search
```
currently we manually refresh the ts_vector index because the PG triggers slow down the dbtool.py import script.
If you want /v1.3/search to return results you must run this SQL statement:

refresh materialized view media_items_search

```

