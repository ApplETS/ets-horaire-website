require_relative '../helpers/printing_helper'
require 'json'

include PrintingHelper
namespace :convert_pdfs do
  COURSES_TO_IGNORE = %w(PRE010)

  desc 'Convert PDFs of courses to a json file'
  task :to_json => :environment do
    print_title 'Convert PDF of courses to a json file'

    @wrote_to_at_least_one_file = false
    folder_path = Rails.root.join(File.join(from_folder, "/*.pdf"))

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

    if @wrote_to_at_least_one_file
      write_log_file
    else
      puts 'Nothing to convert!'
    end
  end

  private

  def from_folder
    ENV['FROM_FOLDER'] || 'files/pdfs'
  end

  def to_folder
    ENV['TO_FOLDER'] || File.join('db/courses', current_environment)
  end

  def current_environment
    ENV['RAILS_ENV'] || 'development'
  end

  def database_folder_appended_with(file)
    Rails.root.join to_folder, file
  end

  def store_to_json(students_type, key, basename)
    file_path = database_folder_appended_with("#{basename}.json")
    return if File.exists?(file_path)

    serialized_bachelors = []
    students_type[key].each do |file_struct|
      bachelor = build_bachelor_from(file_struct)
      serialized_bachelors << bachelor.serialize
    end
    output_to_json(serialized_bachelors, file_path) unless serialized_bachelors.empty?
  end

  def build_bachelor_from(file_struct)
    courses_struct = EtsScheduleParser::PdfParser.parse(file_struct.file_path, COURSES_TO_IGNORE)
    BachelorBuilder.build file_struct, courses_struct
  end

  def output_to_json(hash, file_path)
    puts "- Writing '#{file_path}'"
    File.open(file_path, 'w') { |file| file.write(hash.to_json) }
    @wrote_to_at_least_one_file = true
  end

  def write_log_file
    File.open(database_folder_appended_with('last_modified_timestamp'), 'w') { |file| file.write(Time.now.to_i) }
  end
end