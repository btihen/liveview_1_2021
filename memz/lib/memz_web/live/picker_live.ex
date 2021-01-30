defmodule MemzWeb.PickerLive do
  use MemzWeb, :live_view

  alias Memz.Library

  def mount(_params, _session, socket) do
    passage_names = Library.passage_names()

    {
      :ok,
      socket
      |> assign(:passage_names, passage_names)
      |> next_passage_name()
      |> passage_lookup()
    }
  end

  def render(assigns) do
    ~L"""
    <h1> Welcome</h1>
    <h2><%= @current_name %></h2>
    <pre>
    <%= @passage.text %>
    </pre>

    <% count = String.length(@passage.text) %>
    <p>Memorize <%= count %> characters</p>

    <button phx-click="choose">
      Memorize
    </button>
    <button phx-click="next">
      Next
    </button>
    """
  end

  def handle_event("next", _, socket) do
    {
      :noreply,
      socket
      |> next_passage_name()
      |> passage_lookup()
    }
  end

  def handle_event("choose", _, socket) do
    {:noreply, push_redirect(socket, to: "/game/play/#{socket.assigns.current_name}")}
  end

  defp next_passage_name(socket) do
    [first | rest] = socket.assigns.passage_names
    assign(socket, current_name: first, passage_names: rest ++ [first])
  end

  defp passage_lookup(socket) do
    passage = Library.find_passage_by_name(socket.assigns.current_name)
    assign(socket, passage: passage)
  end
end
