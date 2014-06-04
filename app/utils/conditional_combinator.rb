class ConditionalCombinator
  NO_LIMIT = -1

  attr_writer :before_filter, :comparator, :shovel_filter, :hard_limit

  def initialize
    @before_filter = Proc.new { true }
    @comparator = Proc.new { true }
    @shovel_filter = Proc.new { true }
    @hard_limit = NO_LIMIT
    @combinations = []
  end

  def find_combinations(values, set_size)
    return [] if values.empty? || set_size == 0 || set_size > values.size

    @values = values
    apply_before_filter
    return [] if @values.empty?

    @set_size = set_size
    return collect_in_individual_arrays if set_size == 1

    @combinations = []
    loop_through(0, values.size - set_size, [])
    @combinations
  end

  def reached_limit?
    @reached_limit = (@hard_limit != -1 && @combinations.size >= @hard_limit)
  end

  private

  def apply_before_filter
    @values.keep_if { |value| @before_filter.call(value) }
  end

  def collect_in_individual_arrays
    combinations = []
    @values.each do |value|
      combination = [value]
      combinations << combination if @comparator.call([], value) && add_to_combinations?(combination)
    end
    combinations
  end

  def loop_through(from_index, to_index, combination_stack)
    if to_index == @values.size - 1
      iterate_while_adding(from_index, to_index, combination_stack) do |combination_stack|
        @combinations << combination_stack if add_to_combinations?(combination_stack)
      end
    else
      iterate_while_adding(from_index, to_index, combination_stack) do |combination_stack, index|
        loop_through(from_index + index + 1, to_index + 1, combination_stack)
      end
    end
  end

  def iterate_while_adding(from_index, to_index, combination_stack)
    @values[from_index..to_index].each_with_index do |value, index|
      break if reached_limit?

      combination_stack_duplicate = combination_stack.dup
      combination_stack_duplicate << value if @comparator.call(combination_stack_duplicate, value)
      yield combination_stack_duplicate, index
    end
  end

  def add_to_combinations?(combination_stack)
    combination_stack.size == @set_size && @shovel_filter.call(combination_stack)
  end
end
