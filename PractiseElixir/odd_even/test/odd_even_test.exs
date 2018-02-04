defmodule OddEvenTest do
  use ExUnit.Case
  doctest OddEven

  test "greets the world" do
    assert OddEven.hello() == :world
  end
end
