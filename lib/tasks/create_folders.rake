require_relative '../helpers/printing_helper'

include PrintingHelper
namespace :create_folders do
  FOLDERS = %w(
    tmp/files
    files/inputs
    files/outputs
    files/pdfs
  )

  desc 'Create folder structure for the app'
  task :for_deployment => :environment do
    print_title 'Creating folder structure for app'
    FOLDERS.each do |folder|
      puts " - Creating '#{folder}'"
      FileUtils.mkdir_p(folder)
    end
  end
end