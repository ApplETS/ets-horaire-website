require_relative '../helpers/printing_helper'

include PrintingHelper
namespace :create_folders do
  FOLDERS = %W(
    tmp/files
    files/inputs
    files/outputs
    files/pdfs
  )

  desc 'Create folder structure for the app'
  task :for_deployment => :environment do
    @created_at_least_one_folder = false

    print_title 'Creating folder structure for app'
    FOLDERS.each do |folder|
      folder_path = Rails.root.join(folder)
      unless File.directory?(folder_path)
        puts " - Creating '#{folder}'"
        FileUtils.mkdir_p(folder_path)
        @created_at_least_one_folder = true
      end
    end

    puts 'No folders to create!' unless @created_at_least_one_folder
  end
end