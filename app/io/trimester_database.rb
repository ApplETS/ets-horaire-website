# encoding: UTF-8

class TrimesterDatabase
  ORDERED_TERMS = TrimesterBuilder::TERMS.values
  ORDERED_BACHELORS = BachelorBuilder::NAMES.values

  private_class_method :new
  def initialize
    @last_modified = 0
  end

  def self.instance
    @instance ||= new
    @instance.reload
    @instance
  end

  def reload
    return unless files_changed?

    @trimesters = fetch_trimesters
    @sorted_trimesters = sort_trimesters
  end

  def all
    @trimesters
  end

  def sorted
    @sorted_trimesters
  end

  private

  def database_folder_appended_with(file)
    Rails.root.join 'db/courses', Rails.env, file
  end

  def files_changed?
    load database_folder_appended_with('last_modified.rb')
    return false if JSON_FILES_LAST_MODIFIED == @last_modified

    @last_modified = JSON_FILES_LAST_MODIFIED
    return true
  end

  def fetch_trimesters
    Dir.glob(database_folder_appended_with('*.json')).collect do |trimester_json|
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