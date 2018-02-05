defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "simple expression" do
   	assert Calc.eval("2 + 2") == 4
  end

  test "big expression" do
  	assert Calc.eval("( 1 + ( 2 + ( 7 - 1 ) * ( 5 + 3 ) ) * 4 )") == 201
  end

  test "expression with non-spaced parantheses" do
  	assert Calc.eval("(1 + (2 + (7 - 1) * (5 + 3 )) * 4)") == 201
  end

  test "simple addition" do 
  	assert Calc.eval("2 + 3") == 5
  end

  test "simple multiplication" do 
  	assert Calc.eval("5 * 1") == 5
  end

  test "simple division" do 
  	assert Calc.eval("20 / 4") == 5
  end

  test "division and subtraction" do 
  	assert Calc.eval("20 / 4") == Calc.eval("188976 - 188971")
  end

  test "multiplication nested across parantheses" do 
  	assert Calc.eval("(1 + (8 * 2) * (2 * 10))") == 321
  end

  test "equivalent expressions with different parantheses" do 
  	assert Calc.eval("(1 + (8 * 2) * (2 * 10))") == Calc.eval("(1 + (8 * 2 * 2 * 10))")
  end

  test "combination of all expressions" do 
  	assert Calc.eval("((5 - 3) * (7 + 9) + 9 * 8 + 2 - 5 * 6 * ( 4 + 3))") == -104
  end

  test "negative numbers addition" do
  	assert Calc.eval("(-5 + -4)") == -9
  end
  
end
