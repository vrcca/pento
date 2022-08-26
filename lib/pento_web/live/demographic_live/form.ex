defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    IO.inspect(live_component: "update/2")

    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end

  def handle_event("validate", %{"demographic" => params}, socket) do
    IO.inspect(live_component: "handle_event/3", event: "validate")
    {:noreply, validate_demographic(socket, params)}
  end

  def handle_event("save", %{"demographic" => params}, socket) do
    IO.inspect(live_view: "handle_event/3", event: "save")
    {:noreply, save_demographic(socket, params)}
  end

  defp validate_demographic(%{assigns: %{demographic: demographic}} = socket, params) do
    assign(
      socket,
      :changeset,
      Survey.change_demographic(demographic, params) |> Map.put(:action, :validate)
    )
  end

  defp save_demographic(socket, params) do
    params
    |> assign_current_user_param(socket)
    |> Survey.create_demographic()
    |> case do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  defp assign_current_user_param(params, socket) do
    Map.put(params, "user_id", socket.assigns.current_user.id)
  end
end
