defmodule Prelude.Map do
  @moduledoc "Functions operating on `maps`."

  @doc ~s"""
  Group a map by an array of keys

  Provide a list of maps, and a list of keys to group by. All maps must
  have all the group_by fields, other fields can vary.

  For example:

      iex> group_by(
      ...>  [%{name: "stian", group: 1, cat: 2},
      ...>   %{name: "per",   group: 1, cat: 1}],
      ...>  [:group, :cat])
      %{1 =>
        %{1 => %{cat: 1, group: 1, name: "per"},
          2 => %{cat: 2, group: 1, name: "stian"}}}
  """
  def group_by(maps, groups) when is_list(maps) and is_list(groups) do
    Enum.reduce(maps, %{}, fn x, acc ->
      extract_and_put(acc, x, groups)
    end)
  end

  defp extract_and_put(map, item, groups) do
    path = Enum.map(groups, fn group -> Map.get(item, group) end)
    deep_put(map, path, [item])
  end

  @doc ~s"""
  Put an arbitrarily deep key into an existing map

  If a value already exists at that level, it is turned into a list

  For example:

      iex> map_deep_put(%{}, [:a, :b, :c], "0")
      %{a: %{b: %{c: "0"}}}

      iex> map_deep_put(%{a: %{b: %{c: "1"}}}, [:a, :b, :c, :d], "2")
      %{a: %{b: %{c: [{:d, "2"}, "1"]}}}
  """
  def deep_put(map, path, val) do
    state = {map, []}
    Enum.reduce(path, state, fn x, {acc, cursor} ->
      cursor = [ x | cursor ]
      final = length(cursor) == length(path)
      newval = case get_in(acc, Enum.reverse(cursor)) do
        h when is_list(h) -> [ val | h ]
        nil -> if final, do: val, else: %{}
        h = %{} -> if final, do: [val, h], else: h
        h -> if final, do: [ val, h ], else: [h]
      end
      { put_in(acc, Enum.reverse(cursor), newval), cursor }
    end)
    |> fn x -> elem(x, 0) end.()
  end

  @doc ~s"""
  Remove a map key arbitrarily deep in a structure, similar to put_in

  For example:

      iex> a = {a: %{b: %{c: %{d: 1, e: 1}}}}
      ...> del_in(a, [:a, :b, :c], :d)
      %{a: %{b: %{c: %{e: 1}}}}
  """
  def del_in(object, path, item) do
    obj = get_in(object, path)
    put_in(object, path, Map.delete(obj, item))
  end

  @doc "Turns all string map keys into atoms, leaving existing atoms alone (only top level)"
  def atomify(map) do
    Enum.map(map, fn {k,v} -> {Prelude.String.to_atom(k), v} end)
    |> Enum.into(%{})
  end

  @doc "Turns all atom map keys into strings, leaving existing strings alone (only top level)"
  def stringify(map) do
    Enum.map(map, fn {k,v} -> {Prelude.Atom.to_string(k), v} end)
    |> Enum.into(%{})
  end

  @doc "Converts strings to atoms, but leaves existing atoms alone"
  def to_atom(x) when is_atom(x), do: x
  def to_atom(x) when is_binary(x), do: String.to_atom(x)

  @doc "Appends to an array value in a map, creating one if the key does not exist"
  def append_list(map, key, val) do
    Map.update(map, key, [val], fn x -> List.insert_at(x, 0, val) end)
  end

  @doc "Switch the keys with the values in a map"
  def switch(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.into(%{})
  end
end

