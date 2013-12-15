# -*- encoding : utf-8 -*-

class ScheduleFinder
  class << self
    def combinations_for(courses, courses_per_schedule)
      return [] if courses.empty? || courses_per_schedule == 0 || courses_per_schedule > courses.size
      return generate_one_schedule_per_group(courses) if courses_per_schedule == 1

      courses_combinations = find_combinations_for(courses, courses_per_schedule)
      schedules = courses_combinations.collect { |courses| find_schedules_for(courses) }
      schedules.flatten(1)
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

    def find_combinations_for(courses, courses_per_schedule)
      courses.size == courses_per_schedule ? [courses] : courses.combination(courses_per_schedule).to_a
    end

    def find_schedules_for(courses)
      course_groups = collect_into_list_of_groups(courses)
      possible_combinations = find_possible_combinations_of_groups(course_groups)
      remove_conflicting_schedules(possible_combinations)
    end

    def collect_into_list_of_groups(courses)
      courses.collect do |course|
        course.groups.collect { |group| GroupCourse.new(course.name, group.periods, group.nb) }
      end
    end

    def find_possible_combinations_of_groups(course_groups)
      possible_combinations = course_groups[0]
      (1..course_groups.size-1).each do |index|
        possible_combinations = possible_combinations.product(course_groups[index])
      end
      possible_combinations.collect { |possible_combination| possible_combination.flatten }
    end

    def remove_conflicting_schedules(possible_combinations)
      possible_combinations.find_all do |possible_combination|
        group_pairs = possible_combination.combination(2).to_a

        group_pairs.none? do |group_pair|
          group_pair[0].conflicts? group_pair[1]
        end
      end
    end
  end
end
