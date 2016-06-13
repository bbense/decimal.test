defmodule Decimal do

  @precision 6
  @precision_top 1000_000
  @precision_bottom 100_000

  @doc """
  Return a normalized tuple of { sign , exponent, mantissa }

  """

  def new(int) when is_integer(int) do
      normalize(int)
  end

  def new(float) when is_float(float) and float > 0 do
    {1, positive_normalize(float_to_normal_init(float))}
  end

  def new(float) when is_float(float) and float < 0 do
    {-1, negative_normalize(float_to_normal_init(float))}
  end

  def float_to_normal_init(float) when float > 0 do
    rep = :math.log10(float)
    log10_mantissa = rep - trunc(rep)
    exponent = trunc(rep) + 1
    mantissa = :math.pow(10.0,log10_mantissa) * @precision_bottom
    # use round here?
    {exponent, round(mantissa)}
  end

  def float_to_normal_init(float) when float < 0 do
    rep = :math.log10(abs(float))
    log10_mantissa = rep - trunc(rep)
    exponent = trunc(rep) + 1
    mantissa = :math.pow(10.0,log10_mantissa) * @precision_bottom
    # use round here?
    {0 - exponent, 0 - round(mantissa)}
  end

  @doc """
  Return a tuple { exponent, mantissa} such that
  abs(mantissa) is greater than 10**(precision-1) and
  less than 10**(precision) and int = mantissa * 10**exponent
  """

  #
  def normalize(0) do
   { 0 ,{0 , 0}}
  end

  # This works as long as int starts out in_range
  def normalize(int) when is_integer(int) and int > 0 do
    if in_range(int) do
     {1, {@precision, int} }
    else
     {1, positive_normalize({@precision, int})}
    end
  end

  def normalize(int) when is_integer(int) and int < 0 do
    if in_range(int) do
     {-1, {1 - @precision, int} }
    else
     {-1, negative_normalize({0 - @precision, int})}
    end
  end

  # -0.1 -> { -1, {1, -@precision_top}}
  # -0.9 -> { -1, {0, -9 * @precision_bottom}}
  # -1   -> { -1, {0 , -@precision_top}}
  # -9   -> { -1, {-1, -9 * @precison_bottom}}
  # -10  -> { -1, {-1, @precision_top}}
  def negative_normalize({exponent, mantissa}) do
    if in_range(mantissa) do
      {exponent, mantissa}
    else
       #IO.inspect {exponent, mantissa}
       negative_normalize({exponent + 1, mantissa*10})
    end
  end


  # This only works when the number is < @precision_top
  def positive_normalize({exponent, mantissa}) do
    if in_range(mantissa) do
      {exponent, mantissa}
    else
      #IO.inspect {exponent, mantissa}
      positive_normalize({exponent-1, mantissa*10})
    end
  end

  def to_float({0, {0, 0}}) do
    0.0
  end

  def to_float({sign, {exponent, mantissa}}) when exponent > 0 and sign > 0 do
    if (exponent - @precision) > 0 do
      mantissa * power(exponent - @precision )
    else
      mantissa / power(abs(exponent - @precision))
    end
  end

  def to_float({sign, {exponent, mantissa}}) when exponent <= 0 and sign > 0 do
    mantissa / power(abs(exponent - @precision))
  end

  def to_float({sign, {exponent, mantissa}}) when exponent > 0 and sign < 0 do
    mantissa * power(exponent)
  end

  def to_float({sign, {exponent, mantissa}}) when exponent <= 0 and sign < 0 do
    mantissa / power(@precision + exponent)
  end

  def in_range(int) do
    (abs(int) <= @precision_top && abs(int) > @precision_bottom)
  end

  def power(0) do
    1
  end

  def power(int) when int > 0 do
    1..int |> Enum.reduce(1, fn(_x, acc) -> 10 * acc end)
  end
end
