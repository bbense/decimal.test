defmodule DecimalTest do
  use ExUnit.Case
  doctest Decimal

  test "0 less than 1" do
    assert Decimal.new(0) < Decimal.new(1)
  end

  test "0.1 less than 1" do
    assert Decimal.new(0.1) < Decimal.new(1)
  end

  test "-1 less than 1" do
    assert Decimal.new(-1) < Decimal.new(1)
  end

  test "-1 less than 0" do
    assert Decimal.new(-1) < Decimal.new(0)
  end

  test "-1 less than -0.1" do
    assert Decimal.new(-1) < Decimal.new(-0.1)
  end

  test "-10 less than -9" do
    assert Decimal.new(-10) < Decimal.new(-9)
  end

  test "9 less than 10" do
    assert Decimal.new(-1) < Decimal.new(0)
  end

  test "to_float 55" do
     assert 55.0 == Decimal.new(55) |> Decimal.to_float
  end

  test "to_float -55" do
     assert -55.0 == Decimal.new(-55) |> Decimal.to_float
  end

  test "55 eq 55.0" do
    assert Decimal.new(55) == Decimal.new(55.0)
  end

  test "-55 eq -55.0" do
    assert Decimal.new(-55) == Decimal.new(-55.0)
  end

end
