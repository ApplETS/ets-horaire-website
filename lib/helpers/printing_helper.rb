module PrintingHelper
  def print_title(value)
    middle = "*   #{value}   *"
    wrapper = middle.size.times.collect { '*' }.join
    sides = (middle.size - 2).times.collect { ' ' }.join
    sides = "*#{sides}*"

    puts wrapper
    puts sides
    puts middle
    puts sides
    puts wrapper
  end
end