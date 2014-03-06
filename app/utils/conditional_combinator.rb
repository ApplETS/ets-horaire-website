class ConditionalCombinator
  def self.build
    configuration = Configuration.new
    yield configuration
    new configuration
  end

  private_class_method :new
  def initialize(configuration)
    @comparator = configuration.get_comparator
    @hard_limit = configuration.hard_limit
    @combinations = []
  end

  def find_combinations(values, set_size)
    return [] if values.empty? || set_size == 0 || set_size > values.size
    return collect_in_individual_arrays(values) if set_size == 1

    @set_size = set_size
    @values = values
    @combinations = []

    loop_through(0, values.size - set_size, [])
    @combinations
  end

  def reached_limit?
    @reached_limit = (@hard_limit != -1 && @combinations.size >= @hard_limit)
  end

  private

  def collect_in_individual_arrays(values)
    combinations = []
    values.each do |value|
      combinations << [value] if @comparator.call([], value)
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
    combination_stack.size == @set_size
  end

  class Configuration
    NO_LIMIT = -1
    attr_accessor :hard_limit

    def initialize
      @hard_limit = NO_LIMIT
    end

    def get_comparator
      @comparator
    end

    def comparator(&block)
      @comparator = block
    end
  end
end
