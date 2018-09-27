# much from https://gist.github.com/jswny/83e03537830b0d997924e8f1965d88bc
# and https://github.com/odarriba/elixir_jobs

asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add nodes

asdf install erlang 21.0.9
asdf install elixir 1.7.3
asdf install nodejs 8.9.1

asdf global erlang 21.0.9
asdf global elixir 1.7.3
asdf global nodejs 8.9.1

git clone https://bitbucket.org/sidha/faithfulword.git

cd faithfulword

mix local.hex
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

mix deps.get
mix deps.compile
cd assets
npm install
cd ..

# have a postgresql instance running locally on port 5432

# seed db
mix ecto.create

# run locally
mix phx.server

<open browser to localhost:4000>

#build docker

./build.sh

docker-compose up
docker network nginx-network
cd nginx
docker-compose up

<open browser to localhost:80>

### misc notes

https://bitbucket.org/sidha/faithfulword.git

mix phx.new faithfulword --app faithfulword --binary-id
(cd assets && npm i npm@latest -g && npm i -D && npm run deploy && npm install)

mix guardian.gen.secret
l2CguhHAfa+bkRRIuOnVUnzhtJuFvcw4qpkaOP4HzjpqR8sPBkPm6ZXcXOBiEBd6

# toltec -- mix phx.gen.context Accounts User users name:string email:string:unique password_hash:string

mix phx.gen.schema Admin admins email:string encrypted_password:string name:string password:string password_confirmation:string

### misc notes

https://bitbucket.org/sidha/faithfulword.git

mix phx.new faithfulword --app faithfulword --binary-id
(cd assets && npm i npm@latest -g && npm i -D && npm run deploy && npm install)

mix guardian.gen.secret
l2CguhHAfa+bkRRIuOnVUnzhtJuFvcw4qpkaOP4HzjpqR8sPBkPm6ZXcXOBiEBd6

# toltec -- mix phx.gen.context Accounts User users name:string email:string:unique password_hash:string

mix phx.gen.schema Admin admins email:string encrypted_password:string name:string password:string password_confirmation:string

# rename a project

git grep -l 'olivetree' | xargs sed -i '' -e 's/olivetree/faithfulword/g'
mv ./lib/olivetree ./lib/faithfulword
mv ./lib/olivetree.ex ./lib/faithfulword.ex
mv ./test/olivetree ./test/faithfulword
mv ./lib/olivetree_web ./lib/faithfulword_web
mv ./lib/olivetree_web.ex ./lib/faithfulword_web.ex
mix ecto.reset

# add config/prod.secret.exs

```
use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :faithfulword, Faithfulword.Endpoint,
  secret_key_base: "hKnGenEUlnSVHDOy3aIO4/fTgqhZbAckrCBiS6diF2xMoh6tHF9WiDId5lW+pp8p"

# Configure your database
config :faithfulword, Faithfulword.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  hostname: "faithfulword-db",
  database: "faithfulword_prod",
  pool_size: 15
```

