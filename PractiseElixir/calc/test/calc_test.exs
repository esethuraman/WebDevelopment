defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "greets the world" do
    assert Calc.hello() == :world
    assert Calc.main() == 4
  end
end
