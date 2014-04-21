def sqrt(x)
  y = 0
  j = Math.log2(x).floor / 2 - 1

  while (j > -1) do
    temp = y + 2**j
    if temp**2 <= x then
      y = y + 2**j
    end

    j -= 1
  end

  return y
end
