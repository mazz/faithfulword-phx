defmodule FaithfulWord.Gettext do
  use Gettext, otp_app: :faithful_word

  defmacro with_user_locale(user, do: expression) do
    quote do
      locale = Map.get(unquote(user), :locale) || "en"

      Gettext.with_locale(FaithfulWord.Gettext, locale, fn ->
        unquote(expression)
      end)
    end
  end

  defmacro gettext_mail(msgid, vars \\ []) do
    quote do
      FaithfulWord.Gettext.dgettext("mail", unquote(msgid), unquote(vars))
    end
  end

  defmacro gettext_mail_user(user, msgid, vars \\ []) do
    quote do
      locale = Map.get(unquote(user), :locale) || "en"

      Gettext.with_locale(FaithfulWord.Gettext, locale, fn ->
        FaithfulWord.Gettext.dgettext("mail", unquote(msgid), unquote(vars))
      end)
    end
  end
end
