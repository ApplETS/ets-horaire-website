# -*- encoding : utf-8 -*-

class TrimesterBuilder
  class << self
    def build(trimester_slug, serialized_bachelors)
      bachelors = serialized_bachelors.collect { |serialized_bachelor| Bachelor.deserialize(serialized_bachelor) }
      parts = trimester_slug.split('_')
      Trimester.new extract_year_from(parts), extract_term_from(parts) , trimester_slug, bachelors, for_new_students?(parts)
    end

    private

    def extract_term_from(parts)
      term_slug = parts[0]
      Trimester::TERMS.fetch(term_slug)
    rescue KeyError
      raise "Missing term #{term} in TrimesterBuilder."
    end

    def extract_year_from(parts)
      Integer(parts[1])
    end

    def for_new_students?(parts)
      (parts.size == 3 && parts[2] == 'nouveaux')
    end
  end
end