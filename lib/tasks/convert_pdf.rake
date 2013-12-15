require 'json'

namespace :convert_pdf do

  desc 'Convert PDF of courses to a json file'
  task :to_json => :environment do
    folder_path = Rails.root.join('files/pdfs/*.pdf')

    groups = {}
    Dir.glob(folder_path) do |filename|
      parts = File.basename(filename, '.pdf').split('_')
      year = parts[0]
      term = parts[1]
      new_students = parts.size == 4 && parts[3] == 'nouveaux'
      term_key = (new_students ? :new_students : :current_students)

      groups[year] = {} unless groups.has_key?(year)
      groups[year][term] = {new_students: [], current_students: []} unless groups[year].has_key?(term)
      groups[year][term][term_key] << OpenStruct.new(year: year, term: term, slug: parts[2], file_path: filename)
    end

    groups.each_pair do |year, terms|
      terms.each_pair do |term, students_type|
        store_to_json(students_type, :new_students, "#{term}_#{year}_nouveaux")
        store_to_json(students_type, :current_students, "#{term}_#{year}")
      end
    end
  end

  private

  def store_to_json(students_type, key, filename)
    serialized_bachelors = []
    students_type[key].each do |file_struct|
      bachelor = build_bachelor_from(file_struct)
      serialized_bachelors << Convert.to_hash(bachelor)
    end
    output_to_json(serialized_bachelors, filename) unless serialized_bachelors.empty?
  end

  def build_bachelor_from(file_struct)
    courses_stream = PdfStream.from_file(file_struct.file_path)
    courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
    BachelorBuilder.build file_struct, courses_struct
  end

  def output_to_json(hash, filename)
    File.open(Rails.root.join("db/courses/#{filename}.json"), 'w') do |file|
      file.write hash.to_json
    end
  end
end