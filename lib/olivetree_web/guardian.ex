defmodule OlivetreeWeb.Guardian do
  @moduledoc """
  Main Guardian module definition, including how to store and recover users from
  and to the session.
  """

  use Guardian, otp_app: :olivetree
  use SansPassword

  alias Olivetree.Users
  alias Olivetree.Users.Admin

  def subject_for_token(%Admin{} = resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  def resource_from_claims(claims) do
    case Users.get_admin_by_id(claims["sub"]) do
      %Admin{} = admin -> {:ok, admin}
      _ -> {:error, :resource_not_found}
    end
  end

  # # SansPassword

  # @impl true
  # def deliver_magic_link(user, magic_token, extra_params) do
  #   user
  #   |> Olivetree.Mailer.magic_link_email(magic_token, extra_params)
  #   |> Olivetree.Mailer.deliver
  # end

  @impl true
  def deliver_magic_link(_user, magic_token, _opts) do
    require Logger
    alias OlivetreeWeb.Endpoint
    import OlivetreeWeb.Router.Helpers

    Logger.info """

    Typically, we'd send an email here, but for the purposes of this
    demo, you can just click this link in your console:

        #{auth_url(Endpoint, :callback, magic_token)}

    """
  end

end
