defmodule RemixTest do
  use ExUnit.Case
  doctest(Remix)

  test "hello world" do
    assert Remix.hello() == :world
  end
end
