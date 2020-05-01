org = %Org{basename: "the new org", shortname: "new", uuid: Ecto.UUID.generate()}  
org = Repo.insert!(org)

user = %User{reputation: 4200, username: "samuel", name: "Samuel", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1, email: "samuel@faithfulword.app", password: "password", encrypted_password: Bcrypt.hash_pwd_salt("password")}
user = Repo.insert!(user)

# Add a User to an Org

## in order to work with changesets, we need to make sure that our org structure has preloaded associated data

org = Repo.preload(org, [:channels, :users])

org_changeset = Ecto.Changeset.change(org)

## Now we’ll pass our changeset as the first argument to Ecto.Changeset.put_assoc/4:

org_users_changeset = org_changeset |> Ecto.Changeset.put_assoc(:users, [user])

## Lastly, we’ll update the given movie and actor records using our latest changeset:

Repo.update!(org_users_changeset)

# Same as Above but Add a new inline User to an Org

changeset = org_changeset |> Ecto.Changeset.put_assoc(:users, [%User{reputation: 100, username: "gary", name: "Gary", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1, email: "gary@faithfulword.app", password: "password", encrypted_password: Bcrypt.hash_pwd_salt("password")}])

Repo.update!(changeset)

# Querying has_many-based associated records

org2 = Repo.get(Org, 1)

## Query all Orgs with all Users

Repo.all(Query.from o in Org, preload: [:users])

## Query orgs that have users. returns a single org with all of its users

query = Query.from(o in Org, join: a in assoc(o, :users), preload: [users: a])
Repo.all(query)

## Query returns a single Org with a single "Samuel" user

Repo.all(Query.from(o in Org, join: a in assoc(o, :users), where: a.name == "Samuel", preload: [users: a]))

# preload fetched records

org = Repo.get(Org, 1)

org = Repo.preload(org, :users)

## get only the users

org.users

# Using Join Statements

query = Query.from o in Org, join: u in User, on: o.id == u.org_id, where: u.name == "Samuel", select: {o.shortname, u.name}

Repo.all(query)


# The on expression can also use a keyword list

query = Query.from o in Org, join: u in User, on: [id: u.org_id], where: u.name == "Samuel", select: {o.shortname, u.name}

# join on an Ecto query

org = Query.from o in Org, where: [id: 19]
Query.from u in User, join: ^org, on: [id: u.org_id], where: u.name == "Samuel", select: {o.shortname, u.name}
Repo.all(query)

# user























