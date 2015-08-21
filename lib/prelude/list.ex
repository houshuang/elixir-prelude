defmodule Prelude.List do
  @moduledoc "Functions operating on `lists`."

  @doc "Turns an array into a map with the index as the key."
  def indexify(list) when is_list(list) do
    list
    |> Enum.with_index
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.into(%{})
  end

end
