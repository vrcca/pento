defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> assign_changeset()}
  end

  defp assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  defp assign_changeset(%{assigns: %{rating: rating}} = socket) do
    assign(socket, :changeset, Survey.change_rating(rating))
  end

  def handle_event("validate", %{"rating" => params}, socket) do
    {:noreply, validate_rating(socket, params)}
  end

  def handle_event("save", %{"rating" => params}, socket) do
    {:noreply, save_rating(socket, params)}
  end

  defp validate_rating(%{assigns: %{rating: rating}} = socket, params) do
    changeset =
      rating
      |> Survey.change_rating(params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end

  defp save_rating(%{assigns: %{product_index: product_index, product: product}} = socket, params) do
    params
    |> assign_current_user_param(socket)
    |> assign_product_param(socket)
    |> Survey.create_rating()
    |> case do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  defp assign_current_user_param(params, socket) do
    Map.put(params, "user_id", socket.assigns.current_user.id)
  end

  defp assign_product_param(params, socket) do
    Map.put(params, "product_id", socket.assigns.product.id)
  end
end
