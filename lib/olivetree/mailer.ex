defmodule Olivetree.Mailer do
  import Bamboo.Email

  use Bamboo.Mailer, otp_app: :olivetree
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
