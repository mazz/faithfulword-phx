The devnotes.md has some commands to get your environment up but you'll need asdf:

### go to this page and follow how to install asdf:

https://asdf-vm.com/#/core-manage-asdf-vm

then:

```
asdf plugin-add elixir
asdf plugin-add erlang
asdf plugin-add nodejs

asdf install elixir 1.8.1-otp-21
asdf install erlang 21.0
NODEJS_CHECK_SIGNATURES=no asdf install nodejs 10.15.3

asdf global elixir 1.8.1-otp-21
asdf global erlang 21.0
asdf global nodejs 10.15.3
```

### install a local postgresql db server
mac: go to https://postgresapp.com and download latest binary
linux ubuntu: install psql

### now you're ready to install the web app:

```
cd ~/faithfulword-phx
git fetch
git checkout add-hash-id # latest working branch
mix deps.get && mix deps.compile
cd apps/faithful_word_api
cd assets && npm install
cd ../../
python3 -m venv my3venv
source my3venv/bin/activate
pip install -U pip
pip install psycopg2
cd ../faithfulword-phx

./dbimport.py migratefromwebsauna ./2019-05-04-media-item-bin.pgsql faithful_word_dev ; ./dbimport.py convertv12bibletoplaylists faithful_word_dev ; ./dbimport.py convertv12gospeltoplaylists faithful_word_dev ; ./dbimport.py convertv12musictoplaylists faithful_word_dev ; ./dbimport.py normalizemusic faithful_word_dev ; ./dbimport.py normalizegospel faithful_word_dev ; ./dbimport.py normalizepreaching faithful_word_dev ; ./dbimport.py normalizebible faithful_word_dev ; ./dbimport.py misccleanup faithful_word_dev ; mix run apps/db/priv/repo/seeds.exs ; mix run apps/db/priv/repo/hash_ids.exs
### run
mix phx.server
```

### open url in browser
http://localhost:4000/v1.2/books?language-id=en