defmodule FaithfulWordJobs.Test do
  use ExUnit.Case
  doctest FaithfulWordJobs

  test "greets the world" do
    assert FaithfulWordJobs.hello() == :world
  end
end
