defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Survey.Rating

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string
    has_many :ratings, Rating

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :sku])
    |> validate_unit_price()
    |> unique_constraint(:sku)
  end

  def unit_price_changeset(product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_unit_price()
  end

  defp validate_unit_price(changeset) do
    changeset
    |> validate_required([:unit_price])
    |> validate_number(:unit_price, greater_than: 0)
  end
end
