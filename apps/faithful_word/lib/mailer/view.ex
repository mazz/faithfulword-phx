defmodule FaithfulWord.Mailer.View do
  use Phoenix.View, root: "lib/mailer/templates", namespace: FaithfulWord.Mailer
  use Phoenix.HTML

  import FaithfulWord.Gettext
  import FaithfulWord.Utils.FrontendRouter

  def user_appelation(user) do
    FaithfulWord.DB.Schema.User.user_appelation(user)
  end
end
