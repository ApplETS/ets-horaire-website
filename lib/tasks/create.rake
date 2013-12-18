require_relative '../helpers/printing_helper'

include PrintingHelper
namespace :create do
  FOLDERS = %W(
    db/courses
    tmp/files
    files/inputs
    files/outputs
    files/pdfs
  )

  desc 'Create folder structure for the app'
  task :folder_structure => :environment do
    @created_at_least_one_folder = false

    print_title 'Creating folder structure for app'
    FOLDERS.each { |folder| create_folder_structure_using(folder) }
    create_folder_structure_using "db/courses/#{current_environment}"

    puts 'No folders to create!' unless @created_at_least_one_folder
  end

  private

  def current_environment
    ENV['RAILS_ENV'] || 'development'
  end

  def create_folder_structure_using(folder)
    folder_path = Rails.root.join(folder)
    return if File.directory?(folder_path)

    puts " - Creating '#{folder}'"
    FileUtils.mkdir_p(folder_path)
    @created_at_least_one_folder = true
  end
end