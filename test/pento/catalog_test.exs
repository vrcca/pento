defmodule Pento.CatalogTest do
  use Pento.DataCase

  alias Pento.Catalog

  describe "products" do
    alias Pento.Catalog.Product

    import Pento.CatalogFixtures
    import Pento.AccountsFixtures
    import Pento.SurveyFixtures

    @invalid_attrs %{description: nil, name: nil, sku: nil, unit_price: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        sku: 42,
        unit_price: 120.5
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.sku == 42
      assert product.unit_price == 120.5
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        sku: 43,
        unit_price: 456.7
      }

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.sku == 43
      assert product.unit_price == 456.7
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end

    test "markdown_product/2 decresases product price by given amount" do
      unit_price = 500
      amount = 100

      product = product_fixture(unit_price: unit_price)

      assert {:ok, %Product{} = product} = Catalog.markdown_product(product, amount)
      assert product.unit_price == unit_price - amount
    end

    test "markdown_product/2 returns error if amount is greates than products price" do
      unit_price = 500
      amount = unit_price + 100
      product = product_fixture(unit_price: unit_price)

      assert {:error, %Ecto.Changeset{}} = Catalog.markdown_product(product, amount)
    end

    test "list_products_with_user_rating/1 returns all products with ratings preloaded for the given user" do
      user = user_fixture()
      rating1 = rating_fixture(%{user: user})
      rating2 = rating_fixture(%{user: user})
      rating3 = rating_fixture() |> Repo.preload(:user)
      assert result = Catalog.list_products_with_user_rating(user)
      assert fetch_product!(result, rating1).ratings != []
      assert fetch_product!(result, rating2).ratings != []
      assert fetch_product!(result, rating3).ratings == []

      assert result = Catalog.list_products_with_user_rating(rating3.user)
      assert fetch_product!(result, rating1).ratings == []
      assert fetch_product!(result, rating2).ratings == []
      assert fetch_product!(result, rating3).ratings != []
    end
  end

  defp fetch_product!(result, rating) do
    product = Enum.find(result, fn product -> product.id == rating.product_id end)
    refute is_nil(product)
    product
  end
end
