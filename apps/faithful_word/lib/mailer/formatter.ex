defimpl Bamboo.Formatter, for: FaithfulWord.DB.Schema.User do
  def format_email_address(user, _opts) do
    {FaithfulWord.DB.Schema.User.user_appelation(user), user.email}
  end
end
