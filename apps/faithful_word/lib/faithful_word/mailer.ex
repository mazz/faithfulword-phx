defmodule FaithfulWord.Mailer do
  import Bamboo.Email

  use Bamboo.Mailer, otp_app: :faithful_word

  def welcome_email(user, magic_token, _opts) do
    new_email(
      to: user.email,
      from: "noreply@faithfword.app",
      subject: "Welcome to FaithfulWord.",
      html_body: "<strong>FaithfulWord -- Click the link to login</strong></br></br>
      Magic Link:</br></br>https://faithfword.app/login/#{magic_token}",
      text_body: "Thanks for joining!\n\nClick the magic link:\n\nhttps://faithfword.app/login/#{magic_token}"
    )
  end
end
