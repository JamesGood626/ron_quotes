defmodule RonQuotes.QuoteServer do
  use GenServer, restart: :transient

  def start_link(_opts) do
    IO.puts("gen server starting!")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:add_quote, new_quote}, state) do
    new_state =
      state
      |> Map.put(new_quote, %{quote: new_quote, ratings: [], average_rating: 0})

    {:noreply, new_state}
  end

  def handle_call({:add_quote_rating, quote_key, rating}, _from, state) do
    {new_average_rating, new_state} =
      state
      |> Map.get_and_update!(quote_key, fn current_map ->
        {current_map, rate_quote(current_map, rating)}
      end)
      |> calculate_average_rating(quote_key)

    {:reply, new_average_rating, new_state}
  end

  def handle_call({:check_quote_already_in_state, quote_key}, _from, state) do
    {:reply, Map.has_key?(state, quote_key), state}
  end

  ## Public Functions
  def add_quote(new_quote) do
    GenServer.cast(__MODULE__, {:add_quote, new_quote})
  end

  def add_quote_rating(quote_key, rating) do
    GenServer.call(__MODULE__, {:add_quote_rating, quote_key, rating})
  end

  def check_quote_already_in_state(quote_key) do
    GenServer.call(__MODULE__, {:check_quote_already_in_state, quote_key})
  end

  ## Helpers
  defp rate_quote(quote_map, rating) when is_map(quote_map) do
    {_, updated_map} =
      quote_map
      |> Map.get_and_update(:ratings, fn current_ratings ->
        update_ratings(current_ratings, rating)
      end)

    updated_map
  end

  defp update_ratings(current_ratings, rating), do: {current_ratings, [rating | current_ratings]}

  defp calculate_average_rating({_, quote_map}, quote_key) do
    %{^quote_key => %{ratings: ratings}} = quote_map

    len = length(ratings)
    sum = sum(ratings, 0)
    new_average_rating = sum / len

    {_, updated_map} =
      get_and_update_in(quote_map, get_nested_average_rating(quote_key), fn current_average ->
        {current_average, new_average_rating}
      end)

    {new_average_rating, updated_map}
  end

  defp get_nested_average_rating(quote_key),
    do: [Access.key!(quote_key), Access.key!(:average_rating)]

  defp sum([head | []], acc), do: acc + head
  defp sum([head | tail], acc), do: sum(tail, acc + head)
end
