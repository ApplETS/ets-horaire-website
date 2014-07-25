require 'colorize'

module PrintingHelper
  def print_title(value)
    middle = "*   #{value}   *"
    wrapper = middle.size.times.collect { '*' }.join
    sides = (middle.size - 2).times.collect { ' ' }.join
    sides = "*#{sides}*"

    puts wrapper.blue
    puts sides.blue
    puts middle.blue
    puts sides.blue
    puts wrapper.blue
    puts ''
  end
end