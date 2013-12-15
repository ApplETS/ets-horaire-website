# encoding: UTF-8

class Database
  ORDERED_TERMS = TrimesterBuilder::TERMS.values
  ORDERED_BACHELORS = BachelorBuilder::NAMES.values

  private_class_method :new
  def initialize
    @trimesters = fetch_trimesters
    @sorted_trimesters = sort_trimesters
  end

  def self.instance
    @instance ||= new
  end

  def all
    @trimesters
  end

  def sorted
    @sorted_trimesters
  end

  def find_by_slug(trimester_slug)
    @trimesters.find { |trimester| trimester.slug == trimester_slug }
  end

  def find_bachelor_by_slug_and_trimester_slug(bachelor_slug, trimester_slug)
    trimester = @trimesters.find { |trimester| trimester.slug == trimester_slug }
    return nil if trimester.nil?

    bachelor = trimester.bachelors.find { |bachelor| bachelor.slug == bachelor_slug }
    return nil if bachelor.nil?

    bachelor.trimester = trimester
    bachelor
  end

  private

  def fetch_trimesters
    Dir.glob('db/courses/*.json').collect do |trimester_json|
      trimester_slug = File.basename(trimester_json, '.json')
      file_content = File.open(trimester_json).read
      serialized_bachelors = JSON.parse(file_content)
      TrimesterBuilder.build(trimester_slug, serialized_bachelors)
    end
  end

  def sort_trimesters
    sorted_by_year = @trimesters.sort { |x, y| y.year <=> x.year }
    split_by_year = sorted_by_year.chunk{ |trimester| trimester.year }.collect{ |trimesters| trimesters[1] }
    sorted_by_terms = split_by_year.collect { |trimesters_pack| sort_by_terms(trimesters_pack) }
    sort_by_bachelor(sorted_by_terms.flatten)
  end

  def sort_by_terms(trimesters)
    trimesters.sort { |x, y| prioritize_new_student_term(x, y) }
  end

  def prioritize_new_student_term(x, y)
    return (ORDERED_TERMS.index(x.term) <=> ORDERED_TERMS.index(y.term)) unless (x.term == y.term)

    x_new_student_int_value = (x.for_new_students? ? 1 : 0)
    y_new_student_int_value = (y.for_new_students? ? 1 : 0)
    x_new_student_int_value <=> y_new_student_int_value
  end

  def sort_by_bachelor(trimesters)
    trimesters.collect do |trimester|
      bachelors = trimester.bachelors.sort { |x, y| ORDERED_BACHELORS.index(x.name) <=> ORDERED_BACHELORS.index(y.name)  }
      Trimester.new trimester.year, trimester.term, trimester.slug, bachelors, trimester.for_new_students?
    end
  end
end