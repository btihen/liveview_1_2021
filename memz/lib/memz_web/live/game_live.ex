defmodule MemzWeb.GameLive do
  use MemzWeb, :live_view
  # alias Memz.Game
  alias Memz.Library

  def mount(%{"name" => name}, _session, socket) do
    passage = Library.find_passage_by_name(name)

    # override steps stored in DB - make memorize steps dependent on text length
    steps = ceil(String.length(passage.text) / 15)
    steps = cond do
      steps > 10 -> 10
      true       -> steps
    end
    passage = %{passage | steps: steps}

    # socket = assign(socket, passage: passage)
    {:ok, assign(socket, passage: passage)}
  end

  def render(assigns) do
    ~L"""
    <h1> Welcome</h1>
    <%= live_component @socket, MemzWeb.EraserComponent,
                      id: "game", passage: @passage %>
    """
  end
end
