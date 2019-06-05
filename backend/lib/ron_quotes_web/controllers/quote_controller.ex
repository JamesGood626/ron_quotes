defmodule RonQuotesWeb.QuoteController do
  use RonQuotesWeb, :controller
  import SizeGuard
  alias RonQuotes.QuoteServer

  # SHOULD HAVE DONE THIS INSTEAD.
  # UPON STARTING THE SERVER...
  # REPEATEDLY CALL THE API TO BUILD UP STATE WITH THE QUOTES
  # Once there are no more unique keys then api calls will end.
  # As you're building up the map. You'll add the fetched quotes
  # under keys such as "0-4", "5-12", "13+"
  # to facilitate easy retrieval of the sized quotes.
  def get_quote(conn, _params) do
    new_quote = fetch_quote()

    case QuoteServer.check_quote_already_in_state(new_quote) do
      true ->
        json(conn, %{data: new_quote})

      false ->
        QuoteServer.add_quote(new_quote)
    end

    json(conn, %{data: new_quote})
  end

  def get_quote_of_size(conn = %{params: %{"size" => size}}, _params) do
    json(conn, %{data: fetch_desired_quote_size(size)})
  end

  def add_quote_rating(conn, %{"rating" => rating, "quote_key" => quote_key}) do
    data = QuoteServer.add_quote_rating(quote_key, String.to_integer(rating))
    json(conn, %{data: data})
  end

  #####################
  ## Private Helpers ##
  #####################
  defp fetch_quote() do
    case HTTPoison.get!("https://ron-swanson-quotes.herokuapp.com/v2/quotes/") do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body |> mapify_and_extract()

      _ ->
        "Oops... Something went wrong."
    end
  end

  defp mapify_and_extract(data), do: Poison.decode!(data) |> Enum.at(0)

  defp get_string_length(str) do
    len =
      str
      |> String.split()
      |> length()

    {len, str}
  end

  defp fetch_desired_quote_size("small", {len, str})
       when is_binary(str) and is_small(len) do
    str
  end

  defp fetch_desired_quote_size("medium", {len, str})
       when is_binary(str) and is_medium(len) do
    str
  end

  defp fetch_desired_quote_size("large", {len, str})
       when is_binary(str) and is_large(len) do
    str
  end

  defp fetch_desired_quote_size("small", _str \\ nil) do
    {len, str} = fetch_quote() |> get_string_length()
    fetch_desired_quote_size("small", {len, str})
  end

  defp fetch_desired_quote_size("medium", _str) do
    {len, str} = fetch_quote() |> get_string_length()
    fetch_desired_quote_size("medium", {len, str})
  end

  defp fetch_desired_quote_size("large", _str) do
    {len, str} = fetch_quote() |> get_string_length()
    fetch_desired_quote_size("large", {len, str})
  end

  # What I was able to refactor away by using custom guards...
  # for small and large too.
  # defp fetch_desired_quote_size("large", str)
  #      when is_binary(str) do
  #   {len, str} = get_string_length(str)

  #   case len >= 13 do
  #     true ->
  #       str

  #     false ->
  #       fetch_desired_quote_size("large")
  #   end
  # end
end
