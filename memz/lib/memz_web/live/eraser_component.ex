defmodule MemzWeb.EraserComponent do
  use Phoenix.LiveComponent
  alias Memz.Game

  def update(assigns, socket) do
    steps_total = assigns.passage.steps
    paragraph = assigns.passage.text

    {:ok, assign(socket, game: Game.new(steps_total, paragraph))}
  end

  def render(assigns) do
    ~L"""
    <pre><%= @game.paragraph %></pre>
    <h2>
      Memorize text in <%= @game.steps_total %> steps
    </h2>
    <button phx-click="erase" phx-target="<%= @myself %>">
      Erase
    </button>
    """
  end

  # when there is no plan, then choose a new challenge
  def handle_event("erase", _, %{assigns: %{game: %{plan: []}}} = socket) do
    {:noreply, push_redirect(socket, to: "/game/choose")}
  end

  def handle_event("erase", _, socket) do
    {:noreply, erase(socket)}
  end

  defp erase(socket) do
    socket
    |> assign(game: Game.erase(socket.assigns.game))
  end
end
