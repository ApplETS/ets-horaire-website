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
        bachelor = build_bachelor_from(pdf)
        hash << Convert.to_hash(bachelor)
      end

      output_to_json(hash, folder)
    end
  end

  private

  def build_bachelor_from(filename)
    bachelor_slug = File.basename(filename, '.pdf')
    courses_stream = PdfStream.from_file(filename)
    courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
    BachelorBuilder.build bachelor_slug, courses_struct
  end

  def output_to_json(hash, folder)
    trimester = Pathname.new(folder).basename.to_s
    File.open("files/courses/#{trimester}.json", 'w') do |file|
      file.write hash.to_json
    end
  end
end