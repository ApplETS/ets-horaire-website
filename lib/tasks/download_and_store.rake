# -*- encoding : utf-8 -*-
require_relative '../helpers/printing_helper'
require 'ostruct'

include PrintingHelper
namespace :download_and_store do
  ETSMTL = 'http://etsmtl.ca'
  WEBPAGE = "#{ETSMTL}/horaires-bac"
  FILE_PATH = "#{Rails.root.join('tmp/files/horaires.html')}"
  TERMS = {
    'hiver' => 'hiver',
    'été' => 'ete',
    'automne' => 'automne'
  }

  desc 'Download PDFs from etsmtl.ca, store them and convert them to JSON for easy use'
  task :pdfs_from_etsmtl => :environment do
    print_title 'Downloading PDFs from etsmtl.ca'

    #download_pdf_webpage
    html_page = read_file_as_html

    for_each_table_in(html_page) do |table, term, new_students_columns|
      for_each_cell_in(table, new_students_columns) do |cell, new_student_column|
        link = (cell/'a:nth-child(1)').first
        download(link, term, new_student_column) unless link.nil?
      end
    end
  end

  private

  def download_pdf_webpage
    FileUtils.rm(FILE_PATH) if File.exist?(FILE_PATH)
    puts "- Downloading '#{WEBPAGE}' to '#{FILE_PATH}'"
    IO.popen("wget -qO- #{WEBPAGE} -O #{FILE_PATH}") {}
  end

  def read_file_as_html
    File.open(FILE_PATH, 'r') { |f| Hpricot(f) }
  end

  def extract_terms_from(html_page)
    terms = (html_page/'.Titre3')[0..-2]
    terms.collect do |term|
      text = term.inner_text.strip.downcase
      title_match_data = text.match(/(\w+) (\d+)/)

      term = title_match_data[1]
      slug = TERMS[term]
      year = title_match_data[2]

      OpenStruct.new(year: year, name: term, slug: slug)
    end
  end

  def for_each_table_in(html_page)
    terms = extract_terms_from(html_page)
    course_pdfs_tables = (html_page/'.etsTableauDonnees')[0..-2]

    course_pdfs_tables.each_with_index do |table, index|
      term = terms[index]
      new_students_columns = determine_new_students_columns_from(table)

      yield table, term, new_students_columns
    end
  end

  def determine_new_students_columns_from(table)
    headers = (table/'th')[1..-1]

    headers.each_with_index.collect do |header, index|
      text = header.inner_text.downcase
      text.include?('nouveaux')
    end
  end

  def for_each_cell_in(table, new_student_columns)
    (table/'tbody tr').each do |row|
      cells = (row/'td')[1..-1]

      new_student_columns.each_with_index do |new_student_column, index|
        yield cells[index], new_student_column
      end
    end
  end

  def download(link, term, new_student_column)
    href = File.join(ETSMTL, link.attributes['href'])
    basename = File.basename(href, '.pdf')
    program = basename.split('_')[1].downcase
    new_filename = "#{term.year}_#{term.slug}_#{program}#{new_student_column ? '_nouveaux' : ''}.pdf"
    filename_path = Rails.root.join('files/pdfs/', new_filename)

    return if File.exist?(filename_path)
    puts "- Downloading '#{href}' to '#{filename_path}'"
    IO.popen("wget -qO- -4 #{href} -O #{filename_path}") {}
  end
end