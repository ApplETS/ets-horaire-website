# -*- encoding : utf-8 -*-

class ConditionalCombinator
  NO_LIMIT = -1

  def initialize(hard_limit = NO_LIMIT)
    @hard_limit = hard_limit
    @combinations = []
  end

  def find_combinations(values, set_size, &block)
    return [] if values.empty? || set_size == 0 || set_size > values.size
    return collect_in_individual_arrays(values, block) if set_size == 1

    @set_size = set_size
    @values = values
    @combinations = []

    loop_through(0, values.size - set_size, [], block)
    @combinations
  end

  def reached_limit?
    @reached_limit = (@hard_limit!= -1 && @combinations.size >= @hard_limit)
  end

  private

  def collect_in_individual_arrays(values, block)
    combinations = []
    values.each do |value|
      combinations << [value] if block.call([], value)
    end
    combinations
  end

  def loop_through(from_index, to_index, combination_stack, block)
    if to_index == @values.size - 1
      iterate_while_adding(from_index, to_index, combination_stack, block) do |combination_stack|
        @combinations << combination_stack if combination_stack.size == @set_size
      end
    else
      iterate_while_adding(from_index, to_index, combination_stack, block) do |combination_stack, index|
        loop_through(from_index + index + 1, to_index + 1, combination_stack, block)
      end
    end
  end

  def iterate_while_adding(from_index, to_index, combination_stack, block)
    @values[from_index..to_index].each_with_index do |value, index|
      break if reached_limit?

      combination_stack_duplicate = combination_stack.dup
      combination_stack_duplicate << value if block.call(combination_stack_duplicate, value)
      yield combination_stack_duplicate, index
    end
  end
end
