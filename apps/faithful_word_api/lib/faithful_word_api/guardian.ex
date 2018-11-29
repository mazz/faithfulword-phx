defmodule FaithfulWordApi.Guardian do
  @moduledoc """
  Main Guardian module definition, including how to store and recover users from
  and to the session.
  """

  use Guardian, otp_app: :faithful_word

  require Logger
  alias FaithfulWord.Accounts
  alias FaithfulWord.Accounts.Admin

  def subject_for_token(%Admin{} = resource, _claims) do
    Logger.info("subject_for_token resource")
    IO.inspect(resource)
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    Logger.info("subject_for_token")
    {:error, :unknown_resource}
  end

  def resource_from_claims(claims) do
    Logger.info("resource_from_claims")
    IO.inspect(claims)

    case Accounts.get_admin_by_id(claims["sub"]) do
      %Admin{} = admin -> {:ok, admin}
      _ -> {:error, :resource_not_found}
    end
  end

end
