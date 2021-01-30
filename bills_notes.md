# Notes: 27.01.2021

## Lesson 1: Constructor, Reducer, Converter

```
# constructor
"turtle"
# function (converter) takes something and returns something else
to_string
# reducer
# input |> constructor |> reducer (handlers)         |> converter
:turtle |> to_string   |> Kernel.<>(", mutant ninja") |> String.length
```

## get info (i)
```
[{:one, 1}, {:two, 2}]
> [one: 1, two: 2]
# info on last thing in iex
i

# use tab to see options in iex
[{:one, 1}, {:two, 2}] |> Map.<tab>

# input |> constructor
[{:one, 1}, {:two, 2}] |> Map.new
> %{one: 1, two: 2}
```

## add to: Map.put
```
# input              |> constructor |> reducer      |> converter (to enumerable)
[{:one, 1}, {:two, 2}] |> Map.new |> Map.put(:three, 3) |> Map.to_list
```

## new phoenix live project (memory)

```
mix phx.new memz --live
cd memz

# first time
cd assets
npm install
cd ..
mix deps.get
mix ecto.create

# start app
mix phx.server

# or better for dev:
iex -S mix phx.server
```

## git management

```
git pull upstream main
git push
```

# create mask
```
text = "Did you try turning it off and on again?"
len = String.length(text)
times = 4
mask = 1..len |> Enum.shuffle |> Enum.chunk_every(len/times)
```

## VS Code fix (when in class / not project):

1) start vscode inside the phoenix (memz) project folder:
```
cd class_repo
cd memz
code .
```

2)
a) start vscode inside class repo
```
cd class_repo
code .
```
b) In settings ElixirLS: change `Project Dir` from blank to `memz` as shown below.
c) restart vscode

## Day 2 - 28.01.2021

* **Constructor** - takes input and returns the module type (Struct)
* **Reducer** - takes the module type (Struct) and updates it and returns it
* **Converter** - takes the module type (Struct) and returns the relevant output for other uses


### notation

```
# shorthand
& &1

# for:
fn x -> (x end)
```


### alternative test method

```
# memz/lib/memz/game.ex
defmodule Memz.Game do
  defstruct steps_total: 4, plan: [], paragraph: ""

  def new(steps, paragraph, options \\ %{}) do
    chunk = ceil(String.length(paragraph) / steps)

    shuffle_fn = options[:shuffle_fn] || &Enum.shuffle/1
    plan =
      1..String.length(paragraph)
      |> shuffle_fn.()
      |> Enum.chunk_every(chunk)

    %__MODULE__{paragraph: paragraph, plan: plan}
  end
  def erase(%{plan: [current | plan], paragraph: paragraph} = game) do
    new_paragraph =
      paragraph
      |> String.to_charlist()
      |> Enum.with_index(1)
      |> Enum.map(fn {char, index} ->
        replace_character(index in current, char)
      end)
      |> List.to_string()
    %{game | plan: plan, paragraph: new_paragraph}
  end
  def replace_character(true, _char), do: '_'
  def replace_character(false, char), do: char
end


# memz/test/game_test.exs
defmodule Memz.GameTest do
  use ExUnit.Case
  alias Memz.Game
  @paragraph "abcde"
  @steps 2
  test "Memz.Game constructor creates game" do
    assert length(game().plan) == 2
  end

  test "Memz.Game it flows from constructor to reducer" do
    %Game{plan: [[1, 2], [3, 4, 5]], paragraph: @paragraph}
    |> assert_key(:plan, [[1, 2], [3, 4, 5]])
    game()
    |> assert_key(:plan, [[1, 2, 3], [4, 5]])
    |> assert_key(:paragraph, "abcde")
    |> Game.erase()
    |> assert_key(:plan, [[3, 4, 5]])
    |> assert_key(:paragraph, "__cde")
    |> assert_key(:plan, [[4, 5]])
    |> assert_key(:paragraph, "___de")
    |> Game.erase()
    |> assert_key(:plan, [])
    |> assert_key(:paragraph, "_____")
  end

  defp game, do: Game.new(@steps, @paragraph)
  defp game(), do: Game.new(@steps, @paragraph, %{shuffle_fn: fn(list) -> list end})

  defp assert_key(game, key, value) do
    assert value == Map.get(game, key)
    game
  end
end
```
