defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, attrs) do
    changeset = change_recipient(recipient, attrs)

    if changeset.valid? do
      :timer.sleep(10000)
      {:ok, recipient}
    else
      {:error, changeset}
    end
  end
end
