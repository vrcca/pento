defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok, assign_new(socket)}
  end

  defp assign_new(socket) do
    socket
    |> assign_recipient()
    |> assign_changeset()
  end

  defp assign_recipient(socket) do
    assign(socket, :recipient, %Recipient{})
  end

  defp assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    assign(socket, :changeset, Promo.change_recipient(recipient))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event(
        "save",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    with {:ok, _recipient} <- Promo.send_promo(recipient, recipient_params) do
      {:noreply,
       socket
       |> assign_new()
       |> put_flash(:info, "Email sent!")}
    else
      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, Map.put(changeset, :action, :validate))}
    end
  end
end
