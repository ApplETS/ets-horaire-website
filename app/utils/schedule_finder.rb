# -*- encoding : utf-8 -*-

class ScheduleFinder
  NO_LIMIT = ConditionalCombinator::NO_LIMIT

  def initialize(hard_limit = NO_LIMIT)
    @conditional_combinator = ConditionalCombinator.new(hard_limit)
  end

  def combinations_for(courses, courses_per_schedule)
    group_courses = flatten(courses)
    @conditional_combinator.find_combinations(group_courses, courses_per_schedule) do |groups_combinations, group|
      does_not_conflicts_with?(groups_combinations, group) && (block_given? ? yield(groups_combinations, group) : true)
    end
  end

  def reached_limit?
    @conditional_combinator.reached_limit?
  end

  private

  def generate_one_schedule_per_group(courses)
    schedules = []
    courses.each do |course|
      course.groups.each do |group|
        schedules << [GroupCourse.new(course.name, group.periods, group.nb)]
      end
    end
    schedules
  end

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
