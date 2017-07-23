defmodule Circles.Web.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  def traverse_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, _ ->
      String.replace(msg, "%{#{key}}", to_string(value))
    end)
  end
end
