defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  @user_activity_topic "user_activity"

  def track_user(pid \\ self(), user, product) do
    track(pid, @user_activity_topic, product.name, %{users: [%{email: user.email}]})
  end

  def list_products_and_users do
    @user_activity_topic
    |> list()
    |> Enum.map(&extract_product_with_users/1)
  end

  def subscribe_user_activity() do
    PentoWeb.Endpoint.subscribe(@user_activity_topic)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas) do
    metas
    |> Enum.map(&get_in(&1, [:users]))
    |> List.flatten()
    |> Enum.uniq()
  end
end
