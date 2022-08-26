defmodule PentoWeb.RatingLive.Show do
  use Phoenix.Component
  use Phoenix.HTML

  def stars(assigns) do
    ~H"""
    <div>
      <h4>
        <%= @product.name %>
        <%= raw(stars_icons(@rating.stars)) %>
      </h4>
    </div>
    """
  end

  defp stars_icons(stars) do
    stars
    |> filled_stars()
    |> Enum.concat(unfilled_stars(stars))
    |> Enum.join(" ")
  end

  defp filled_stars(stars) do
    List.duplicate("&#x2605", stars)
  end

  defp unfilled_stars(stars) do
    List.duplicate("&#x2606", 5 - stars)
  end
end
