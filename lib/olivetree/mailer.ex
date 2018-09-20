defmodule Olivetree.Mailer do
  import Bamboo.Email

  use Bamboo.Mailer, otp_app: :olivetree

  def magic_link_email(user, magic_token, _opts) do
    new_email(
      to: user.email,
      from: "noreply@objectaaron.com",
      subject: "Welcome back to Olivetree",
      html_body: "<strong>Olivetree -- Click the link to login</strong></br></br>
      Magic Link:</br></br>https://objectaaron.com/login/#{magic_token}",
      text_body: "Thanks for joining!\n\nClick the magic link:\n\nhttps://objectaaron.com/login/#{magic_token}"
    )
  end

  def welcome_email((user, magic_token, _opts)) do
    new_email(
      to: user.email,
      from: "noreply@objectaaron.com",
      subject: "Welcome to Olivetree.",
      html_body: "<strong>Olivetree -- Click the link to login</strong></br></br>
      Magic Link:</br></br>https://objectaaron.com/login/#{magic_token}",
      text_body: "Thanks for joining!\n\nClick the magic link:\n\nhttps://objectaaron.com/login/#{magic_token}"
    )
  end
end
