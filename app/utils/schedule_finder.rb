# -*- encoding : utf-8 -*-

class ScheduleFinder
  RESULTS_LIMIT = 100

  def self.build
    configuration = Configuration.new
    yield(configuration) if block_given?
    new configuration
  end

  private_class_method :new
  def initialize(configuration)
    additional_comparator = configuration.get_additional_comparator

    @conditional_combinator = ConditionalCombinator.build do |c|
      c.hard_limit = RESULTS_LIMIT

      c.before_filter &configuration.get_before_filter
      c.comparator do |groups_combinations, group|
        does_not_conflicts_with?(groups_combinations, group) && additional_comparator.call(groups_combinations, group)
      end
      c.shovel_filter &configuration.get_shovel_filter
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
    def initialize
      @additional_comparator = Proc.new { true }
      @shovel_filter = Proc.new { true }
      @before_filter = Proc.new { true }
    end

    def get_before_filter; @before_filter; end
    def get_additional_comparator; @additional_comparator; end
    def get_shovel_filter; @shovel_filter; end

    def before_filter(&block)
      @before_filter = block
    end

    def additional_comparator(&block)
      @additional_comparator = block
    end

    def shovel_filter(&block)
      @shovel_filter = block
    end
  end
end
