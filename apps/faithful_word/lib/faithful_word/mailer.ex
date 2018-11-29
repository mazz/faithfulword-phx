defmodule FaithfulWord.Mailer do
  import Bamboo.Email

  use Bamboo.Mailer, otp_app: :faithful_word

  def welcome_email(user, magic_token, _opts) do
    new_email(
      to: user.email,
      from: "noreply@faithfword.app",
      subject: "Welcome to FaithfulWord.",
      html_body: "<strong>FaithfulWord -- welcome\n\n",
      text_body: "Thanks for joining!\n"
    )
  end
end
