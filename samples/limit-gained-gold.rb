class Game_Party
  instead_of :gain_gold do |original, amount|
    adjusted_amount = [100, amount].min
    original.call(adjusted_amount)
  end
end
