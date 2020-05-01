defmodule Db.Type.PlaylistHashId do
  @moduledoc """
  Convert a media item integer id to hash
  """

  defmodule InvalidPlaylistHashError do
    @moduledoc """
    Exception throwed when hash is not valid
    """
    defexception plug_status: 404, message: "Not found", conn: nil, router: nil
  end

  @coder Hashids.new(
           min_len: 4,
           alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKMNOPQRSTUVWXYZ",
           salt: "F41thfu1W0rDP14YL1ST"
         )

  @doc """
  Encode a given id
  ## Examples
      iex> Db.Type.PlaylistHashId.encode(42)
      "4VyJ"
  """
  @spec encode(Integer.t()) :: String.t()
  def encode(id) do
    Hashids.encode(@coder, id)
  end

  @doc """
  Decode a given hash
  ## Examples
      iex> Db.Type.PlaylistHashId.decode("JbOz")
      {:ok, 1337}
      iex> Db.Type.PlaylistHashId.decode("€€€€€€€€€€€€€€€€€")
      {:error, :invalid_input_data}
  """
  @spec decode(String.t()) :: Integer.t()
  def decode(hash) do
    case do_decode(hash) do
      {:ok, [id]} -> {:ok, id}
      error -> error
    end
  end

  @doc """
  Decode a given hash. Raise if hash is invalid
  ## Examples
      iex> Db.Type.PlaylistHashId.decode!("JbOz")
      1337
      iex> catch_throw(Db.Type.PlaylistHashId.decode!("€€€"))
      Db.Type.PlaylistHashId.InvalidPlaylistHashError
  """
  @spec decode!(String.t()) :: Integer.t()
  def decode!(hash) do
    case do_decode(hash) do
      {:ok, [id]} -> id
      _error -> throw(InvalidPlaylistHashError)
    end
  end

  defp do_decode(hash),
    do: Hashids.decode(@coder, hash)
end
