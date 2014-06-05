# -*- encoding : utf-8 -*-

require 'forwardable'

class ScheduleFinder
  extend Forwardable

  RESULTS_LIMIT = 100

  def_delegators :@conditional_combinator, :shovel_filter=, :reached_limit?

  def initialize
    @shovel_filter = Proc.new { true }
    @conditional_combinator = ConditionalCombinator.new
    @conditional_combinator.comparator = Proc.new do |groups_combinations, group|
      does_not_conflicts_with?(groups_combinations, group)
    end
  end

  def combinations_for(courses, courses_per_schedule)
    @conditional_combinator.find_combinations(courses, courses_per_schedule)
  end

  private

  def does_not_conflicts_with?(groups_combinations, group)
    groups_combinations.none? do |comparable_group_course|
      comparable_group_course.conflicts?(group)
    end
  end
end
