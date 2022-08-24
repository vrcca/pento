defmodule Pento.Survey.Demographic.Query do
  import Ecto.Query
  alias Pento.Survey.Demographic

  def base do
    Demographic
  end

  def for_user(query \\ base(), user) do
    where(query, [d], d.user_id == ^user.id)
  end
end
