defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  schema "demographics" do
    field :gender, Ecto.Enum, values: [:male, :female, :other, :prefer_not_to_say]
    field :year_of_birth, :integer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    current_year = DateTime.utc_now().year

    demographic
    |> cast(attrs, [:gender, :year_of_birth, :user_id])
    |> validate_required([:gender, :year_of_birth, :user_id])
    |> validate_inclusion(:year_of_birth, 1900..current_year)
    |> unique_constraint(:user_id)
  end
end
