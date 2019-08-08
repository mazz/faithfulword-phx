# Create a new droplet from marketplace (Docker) 
# Backup database from docker volume
Database volume is needed to start the server. The current deployed volume is called `faithfulword-phx_postgres-data`
We need to create a the volume in the new server `docker volume create faithfulword-phx_postgres-data`

Once created the volume in the new node, we can backup the volume using next command:
`docker run -v faithfulword-phx_postgres-data:/volume --rm loomchild/volume-backup backup - | ssh root@<new-server-ip> docker run -i -v faithfulword-phx_postgres-data:/volume --rm loomchild/volume-backup restore -`
# Clone the github repo
# Create the acme.json and put the correct permission
`touch acme.json`
`chmod 600 acme.json`
# Create the secrets for docker-swarm
Every secret must match with the environment variables defined here: `config/release.exs`. All the environment variables are prefixed with _FW_
