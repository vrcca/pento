defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component

  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok, assign_user_activity(socket)}
  end

  defp assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
