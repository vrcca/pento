defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:", correct_number: Enum.random(1..10))}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
    <%= @message %>
    </h2>
    <h2>
    <%= for n <- 1..10 do %>
    <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
    <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => number}, socket) do
    {score, message} =
      if socket.assigns.correct_number == String.to_integer(number) do
        message = "Your guess: #{number}. Right!"
        score = socket.assigns.score + 1
        {score, message}
      else
        message =
          "Your guess: #{number}. Wrong. It was: #{socket.assigns.correct_number}! Guess again. "

        score = socket.assigns.score - 1
        {score, message}
      end

    {:noreply, assign(socket, message: message, score: score, correct_number: Enum.random(1..10))}
  end
end
