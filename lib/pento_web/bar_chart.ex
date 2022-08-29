defmodule PentoWeb.BarChart do
  def make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  def make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  def render_bar_chart(chart, title, subtitle, x_axis, y_axis) do
    Contex.Plot.new(500, 400, chart)
    |> Contex.Plot.titles(title, subtitle)
    |> Contex.Plot.axis_labels(x_axis, y_axis)
    |> Contex.Plot.to_svg()
  end
end
