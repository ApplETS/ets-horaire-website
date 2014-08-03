class SortTrimesters
  ORDERED_TERMS = TrimesterBuilder::TERMS.values
  ORDERED_BACHELORS = BachelorBuilder::NAMES.values

  class << self
    def by_terms_then_year(trimesters)
      sorted_by_year = trimesters.sort { |x, y| y.year <=> x.year }
      split_by_year = sorted_by_year.chunk { |trimester| trimester.year }.collect { |trimesters_by_year| trimesters_by_year[1] }
      sorted_by_terms = split_by_year.collect { |trimesters_pack| sort_by_terms(trimesters_pack) }
      sort_by_bachelor(sorted_by_terms.flatten)
    end

    private

    def sort_by_terms(trimesters)
      trimesters.sort { |x, y| prioritize_new_student_term(x, y) }
    end

    def prioritize_new_student_term(x, y)
      return (ORDERED_TERMS.index(x.term) <=> ORDERED_TERMS.index(y.term)) unless (x.term == y.term)

      x_new_student_int_value = (x.for_new_students? ? 1 : 0)
      y_new_student_int_value = (y.for_new_students? ? 1 : 0)
      y_new_student_int_value <=> x_new_student_int_value
    end

    def sort_by_bachelor(trimesters)
      trimesters.collect do |trimester|
        bachelors = trimester.bachelors.sort { |x, y| ORDERED_BACHELORS.index(x.name) <=> ORDERED_BACHELORS.index(y.name)  }
        Trimester.new trimester.year, trimester.term, trimester.slug, bachelors, trimester.for_new_students?
      end
    end
  end
end