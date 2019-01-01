defmodule FaithfulWord.DB.Query do
  @moduledoc """
  General queries
  """

  import Ecto.Query

  @doc """
  Revert sort by last_inserted
  """
  @spec order_by_last_inserted_desc(Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def order_by_last_inserted_desc(query) do
    order_by(query, desc: :inserted_at)
  end
end
