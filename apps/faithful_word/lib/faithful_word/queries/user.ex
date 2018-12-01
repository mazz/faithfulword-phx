defmodule FaithfulWord.Accounts.Queries.User do
  @moduledoc """
  Module to build queries related to the User schema
  """

  import Ecto.Query, warn: false

  def by_id(query, id) do
    from a in query, where: a.id == ^id
  end

  def by_email(query, email) do
    from a in query, where: a.email == ^email
  end

  def only_user_emails(query) do
    from user in query, select: {user.name, user.email}
  end
end
