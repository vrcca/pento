defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """

  import Pento.AccountsFixtures
  import Pento.CatalogFixtures

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(attrs \\ %{}) do
    {user, attrs} = Map.pop_lazy(attrs, :user, fn -> user_fixture() end)

    {:ok, demographic} =
      attrs
      |> Enum.into(%{
        gender: "male",
        year_of_birth: 1970,
        user_id: user.id
      })
      |> Pento.Survey.create_demographic()

    demographic
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    {user, attrs} = Map.pop_lazy(attrs, :user, fn -> user_fixture() end)
    {product, attrs} = Map.pop_lazy(attrs, :product, fn -> product_fixture() end)

    {:ok, rating} =
      attrs
      |> Enum.into(%{
        stars: 3,
        user_id: user.id,
        product_id: product.id
      })
      |> Pento.Survey.create_rating()

    rating
  end
end
