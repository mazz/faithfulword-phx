defmodule FaithfulWordApi.Guardian do
  @moduledoc """
  Main Guardian module definition, including how to store and recover users from
  and to the session.
  """

  use Guardian, otp_app: :faithful_word_api
  use SansPassword

  alias FaithfulWord.Accounts
  alias FaithfulWord.Accounts.Admin

  def subject_for_token(%Admin{} = resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  def resource_from_claims(claims) do
    case Accounts.get_admin_by_id(claims["sub"]) do
      %Admin{} = admin -> {:ok, admin}
      _ -> {:error, :resource_not_found}
    end
  end

  # SansPassword
  @impl true
  def deliver_magic_link(_user, magic_token, _opts) do
    require Logger
    alias FaithfulWordApi.Endpoint
    # import FaithfulWordApi.Router.Helpers
    alias FaithfulWordApi.Router.Helpers, as: Routes

    _user
    |> FaithfulWord.Mailer.magic_link_email(magic_token, _opts)
    |> FaithfulWord.Mailer.deliver_now

    Logger.debug """

    Sent an email, but for the purposes of this
    demo, you can just click this link in your console:

        #{Routes.login_url(Endpoint, :callback, magic_token)}

    """
  end

end