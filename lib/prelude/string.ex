defmodule Prelude.String do
  @moduledoc "Functions operating on `strings`."

  @doc ~s"""
  Safely convert strings to integers

  Leaves integers alone, and defaults to 0 on error
  """
  def to_int(y) do
    try do
      case y do
        y when is_integer(y) -> y
        y when is_binary(y) -> String.to_integer(y)
        nil -> 0
      end
    rescue
      ArgumentError -> 0
      e -> raise e
    end
  end

  @doc "Checks if a string is the string representation of an integer"
  def is_integer?(str) do
    case Integer.parse(str) do
      {_, ""} -> true
      _       -> false
    end
  end

end
