defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component

  alias Pento.Catalog

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_products_with_average_ratings()
     |> assign_dataset()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp assign_age_group_filter(socket, age_group_filter \\ "all") do
    assign(socket, :age_group_filter, age_group_filter)
  end

  defp assign_products_with_average_ratings(%{assigns: %{age_group_filter: age_group}} = socket) do
    assign(
      socket,
      :products_with_average_ratings,
      get_products_with_average_ratings(%{age_group_filter: age_group})
    )
  end

  defp get_products_with_average_ratings(filter) do
    case Catalog.products_with_average_ratings(filter) do
      [] -> Catalog.products_with_zero_ratings()
      products -> products
    end
  end

  defp assign_dataset(%{assigns: %{products_with_average_ratings: products_ratings}} = socket) do
    assign(socket, :dataset, make_bar_chart_dataset(products_ratings))
  end

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    assign(socket, :chart, make_bar_chart(dataset))
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    assign(socket, :chart_svg, render_bar_chart(chart))
  end

  defp render_bar_chart(chart) do
    Contex.Plot.new(500, 400, chart)
    |> Contex.Plot.titles(title(), subtitle())
    |> Contex.Plot.axis_labels(x_axis(), y_axis())
    |> Contex.Plot.to_svg()
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "average star ratings per product"
  defp x_axis, do: "products"
  defp y_axis, do: "stars"
end
