require 'json'

namespace :convert_pdf do
  desc 'Convert PDF of courses to a json file'
  task :to_json => :environment do
    folder = ENV['FROM_FOLDER']
    trimester = ENV['TRIMESTER']

    hash = []
    Dir.glob("#{folder}/*.pdf") do |pdf|
      filename = File.basename(pdf, '.pdf')
      courses = build_courses_from(pdf)
      hash << {
        "#{filename}" => Convert.to_hash(courses)
      }
    end

    File.open("files/courses/#{trimester}.json", 'w') do |file|
      file.write hash.to_json
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
end