defmodule FaithfulWordApi.GospelV12View do
  use FaithfulWordApi, :view
  alias FaithfulWordApi.GospelV12View

#                render(conn, GospelV12View, "index.json", %{gospel: gospel})
# def render("gospel_v12.json", %{user: user, token: token}) do

  # def render("index.json", %{gospel: gospel}) do
  def render("indexv12.json", %{gospel_v12: gospel_v12}) do
    # %{result: render_many(gospel, GospelV12View, "gospel_v12.json"),
    %{result: render_many(gospel_v12, GospelV12View, "gospel_v12.json"),
      status: "success",
      version: "v1.2"}
  end

  def render("show.json", %{gospel_v12: gospel_v12}) do
    %{data: render_one(gospel_v12, GospelV12View, "gospel_v12.json")}
  end

  # def render("gospel.json", %{gospel: gospel}) do
  #   %{title: gospel.title,
  #   localizedTitle: gospel.localizedTitle,
  #   gid: gospel.uuid,
  #   languageId: gospel.languageId}
  # end

  def render("gospel_v12.json", %{gospel_v12: gospel_v12}) do
    %{title: gospel_v12.title,
    localizedTitle: gospel_v12.localizedTitle,
    gid: gospel_v12.uuid,
    languageId: gospel_v12.languageId}
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
