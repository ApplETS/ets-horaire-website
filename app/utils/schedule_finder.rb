# -*- encoding : utf-8 -*-

require 'forwardable'

class ScheduleFinder
  extend Forwardable

  RESULTS_LIMIT = 100

  def_delegators :@conditional_combinator, :before_filter=, :shovel_filter=, :reached_limit?

  def initialize
    @before_filter = Proc.new { true }
    @shovel_filter = Proc.new { true }
    @conditional_combinator = ConditionalCombinator.new
    @conditional_combinator.comparator = Proc.new do |groups_combinations, group|
      does_not_conflicts_with?(groups_combinations, group)
    end
  end

  def combinations_for(courses, courses_per_schedule)
    group_courses = flatten(courses)
    @conditional_combinator.find_combinations(group_courses, courses_per_schedule)
  end

  private

  def flatten(courses)
    periods = courses.collect do |course|
      course.groups.collect do |group|
        GroupCourse.new(course.name, group.periods, group.nb)
      end
    end
    periods.flatten
  end

  def does_not_conflicts_with?(groups_combinations, group)
    groups_combinations.none? do |comparable_group_course|
      comparable_group_course.conflicts?(group)
    end
  end
end
