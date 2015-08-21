defmodule Prelude do
  # turns {:ok, x} tuples into x. might be useful for pipelines or IEx
  def ok({:ok, x}), do: x
  def ok(y), do: raise y

end
