defimpl Bamboo.Formatter, for: Db.Schema.User do
  def format_email_address(user, _opts) do
    {Db.Schema.User.user_appelation(user), user.email}
  end
end
