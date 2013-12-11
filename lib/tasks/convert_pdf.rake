require 'json'

namespace :convert_pdf do
  desc 'Convert PDF of courses to a json file'
  task :to_json => :environment do
    folder = ENV['FROM_FOLDER']
    folder_path = File.join(Rails.root, folder, '*')

    Dir.glob(folder_path) do |folder|
      pdf_path = File.join(folder, '*.pdf')
      hash = []

      Dir.glob(pdf_path).each do |pdf|
        filename = File.basename(pdf, '.pdf')
        courses = build_courses_from(pdf)
        hash << { filename => Convert.to_hash(courses) }
      end

      output_to_json(hash, folder)
    end
  end

  private

  def build_courses_from(filename)
    courses_stream = PdfStream.from_file(filename)
    courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
    courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
    CourseUtils.cleanup! courses
    courses
  end

  def output_to_json(hash, folder)
    trimester = Pathname.new(folder).basename.to_s
    File.open("files/courses/#{trimester}.json", 'w') do |file|
      file.write hash.to_json
    end
  end
end