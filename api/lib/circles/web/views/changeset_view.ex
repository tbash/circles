defmodule Circles.Web.ChangesetView do
  use Circles.Web, :view

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: Ecto.Changeset.traverse_errors(changeset, &traverse_error/1)}
  end
end
