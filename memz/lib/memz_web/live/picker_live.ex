defmodule MemzWeb.PickerLive do
  use MemzWeb, :live_view

  alias Memz.Library

  def mount(_params, _session, socket) do
    passage_names = Library.passage_names()

    {
      :ok,
      socket
      |> assign(:all, passage_names)
      |> start_from_beginning()
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
      |> next_passage()
      |> passage_lookup()
    }
  end

  def handle_event("choose", _, socket) do
    {:noreply, push_redirect(socket, to: "/game/play/#{socket.assigns.current_name}")}
  end


  defp next_passage(%{assigns: %{passage_names: []}} = socket) do
        start_from_beginning(socket)
  end

  defp next_passage(%{assigns: %{passage_names: [current_name | rest]}} = socket) do
        assign(socket, current_name: current_name, passage_names: rest)
    end

  defp passage_lookup(socket) do
    passage = Library.find_passage_by_name(socket.assigns.current_name)
    assign(socket, passage: passage)
  end

  defp start_from_beginning(socket) do
    [first | rest] = socket.assigns.all
    assign(socket, current_name: first, passage_names: rest)
  end
end
