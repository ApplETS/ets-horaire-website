# -*- encoding : utf-8 -*-

class ScheduleFinder
  def self.build
    configuration = Configuration.new
    yield(configuration) if block_given?
    new configuration
  end

  private_class_method :new
  def initialize(configuration)
    additional_comparator = configuration.get_additional_comparator

    @conditional_combinator = ConditionalCombinator.build do |c|
      c.hard_limit = configuration.hard_limit
      c.comparator do |groups_combinations, group|
        does_not_conflicts_with?(groups_combinations, group) && additional_comparator.call(groups_combinations, group)
      end
    end
  end

  def combinations_for(courses, courses_per_schedule)
    group_courses = flatten(courses)
    @conditional_combinator.find_combinations(group_courses, courses_per_schedule)
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

  class Configuration
    NO_LIMIT = ConditionalCombinator::Configuration::NO_LIMIT
    attr_accessor :hard_limit

    def initialize
      @hard_limit = NO_LIMIT
      @additional_comparator = Proc.new { true }
    end

    def get_additional_comparator
      @additional_comparator
    end

    def additional_comparator(&block)
      @additional_comparator = block
    end
  end
end
