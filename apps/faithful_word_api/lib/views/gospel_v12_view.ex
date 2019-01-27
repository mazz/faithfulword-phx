defmodule FaithfulWordApi.GospelV12View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.GospelV12View

#                render(conn, GospelV12View, "index.json", %{gospel: gospel})
# def render("gospel_v12.json", %{user: user, token: token}) do

  # def render("index.json", %{gospel: gospel}) do
  def render("indexv12.json", %{gospel: gospel}) do
    %{result: render_many(gospel, GospelV12View, "gospel_v12.json"),
      status: "success",
      version: "v1.2"}
  end

  def render("show.json", %{gospel: gospel}) do
    %{data: render_one(gospel, GospelV12View, "gospel_v12.json")}
  end

  # def render("gospel.json", %{gospel: gospel}) do
  #   %{title: gospel.title,
  #   localizedTitle: gospel.localizedTitle,
  #   gid: gospel.uuid,
  #   languageId: gospel.languageId}
  # end

  def render("gospel_v12.json", %{gospel: gospel}) do
    %{title: gospel.title,
    localizedTitle: gospel.localizedTitle,
    gid: gospel.uuid,
    languageId: gospel.languageId}
  end
end



# defmodule ToltecWeb.UserView do
#   use ToltecWeb, :view

#   def render("user.json", %{user: user}) do
#     %{
#       id: user.id,
#       name: user.name,
#       email: user.email
#     }
#   end
# end
