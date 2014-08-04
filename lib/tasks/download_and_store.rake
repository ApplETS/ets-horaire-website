# -*- encoding : utf-8 -*-
require 'colorize'
require_relative '../helpers/printing_helper'

namespace :download_and_store do
  include PrintingHelper

  desc 'Download PDFs from an URL that will be scanned for schedules'
  task :pdfs => :environment do
    url = ENV['FROM_URL']
    (notify_of_usage("Missing url."); next) unless url.present?
    (notify_of_usage("Missing year."); next) unless ENV['BACHELOR_YEAR'].present?
    (notify_of_usage("Missing term."); next) unless ENV['BACHELOR_TERM'].present?

    print_title "Downloading PDFs from #{url}"
    notify_of_overwrite if overwrite_existing?

    bachelor_names = Bachelor::NAMES.keys
    bachelor_names.each do |bachelor_name|
      filename_path = filepath_for(bachelor_name)
      (warn_about_existing(filename_path); next) if skip?(filename_path)

      file_url = file_url_for(url, bachelor_name)
      wget file_url, filename_path
    end
  end

  private

  def skip?(filename_path)
    File.exist?(filename_path) && !overwrite_existing?
  end

  def notify_of_overwrite
    puts "* Overwriting existing files.".yellow
  end

  def notify_of_usage(message)
    puts message.red
    puts "Usage: rake download_and_store:pdfs FROM_URL=http://url BACHELOR_YEAR=9999 BACHELOR_TERM=hiver (FOR_NEW_STUDENTS=0|1) (OVERWRITE_EXISTING=0|1)".red
  end

  def filepath_for(bachelor_name)
    filename = "#{prefix}_#{bachelor_name}#{suffix}.pdf"
    Rails.root.join('files/pdfs/', filename)
  end

  def prefix
    "#{ENV['BACHELOR_YEAR']}_#{ENV['BACHELOR_TERM']}"
  end

  def suffix
    for_new_students? ? "_nouveaux" : ''
  end

  def for_new_students?
    ENV['FOR_NEW_STUDENTS'] == '1'
  end

  def overwrite_existing?
    ENV['OVERWRITE_EXISTING'] == '1'
  end

  def warn_about_existing(filename_path)
    puts "File at ".yellow + filename_path.to_s + " already exists. Skipping download.".yellow
  end

  def file_url_for(url ,bachelor_name)
    File.join(url, "hor_#{bachelor_name.upcase}.pdf")
  end

  def wget(from, to)
    puts "Copying file from #{from.to_s.green}"
    puts "               to #{to.to_s.green}"
    system "wget -qO- -4 #{from.to_s} -O #{to.to_s}"
  end
end