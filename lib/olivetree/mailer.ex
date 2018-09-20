defmodule Olivetree.Mailer do
  import Bamboo.Email

  use Bamboo.Mailer, otp_app: :olivetree

  def magic_link_email(user, magic_token, _opts) do
    new_email(
      to: user.email,
      from: "noreply@olivetree.app",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>\n\nClick the magic link:</br></br>http://olivetree.app/login/#{magic_token}",
      text_body: "Thanks for joining!\n\nClick the magic link:\n\nhttp://olivetree.app/login/#{magic_token}"
    )
  end

  def welcome_email do
    new_email(
      to: "michaelkhanna@gmail.com",
      from: "noreply@olivetree.app",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
