defmodule Prelude do
  @moduledoc "Various utility functions that I found useful in my own programming.

  This module contains functions that did not fit in anywhere else."

  @doc "Turns `{:ok, x}` tuples into x.

  Might be useful for pipelines or IEx. Not safe, will raise exception on
  anything but a two-element tuple with `:ok` as the first element."
  def ok({:ok, x}), do: x
  def ok(x), do: raise x

end
