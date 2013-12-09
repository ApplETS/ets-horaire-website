# encoding: UTF-8

require 'net/http'

class SelectFileController < ApplicationController
  before_filter :ensure_has_specified_file, only: :upload

  def index
  end

  def upload
    upload_file_to_server
    redirect_to schedule_path
  rescue EtsHoraireException => e
    flash[:error] = e.message
    render 'index'
  rescue Exception => e
    # log the error
    raise e
  end

  private

  def ensure_has_specified_file
    unless file_from_computer? || file_from_url?
      flash[:error] = 'Veuillez spécifier un fichier!'
      render 'index'
    end
  end

  def file_from_computer?
    params['file-group'] == 'input-file' && params.has_key?('input-file')
  end

  def file_from_url?
    params['file-group'] == 'input-link' && !params['input-link'].empty?
  end

  def upload_file_to_server
    if params['file-group'] == 'input-file'
      upload_file_from_computer
    elsif params['file-group'] == 'input-link'
      upload_file_from_link
    end
  end

  def upload_file_from_computer
    file_from_computer = params['input-file']
    filename = file_from_computer.original_filename
    ensure_is_pdf filename

    write_to_file_named(filename) do |file_on_server|
      file_on_server.write file_from_computer.tempfile.read
    end
  end

  def upload_file_from_link
    url_of_file = params['input-link']
    filename = File.basename(url_of_file)
    ensure_is_pdf filename

    url = URI.parse(url_of_file)
    http = Net::HTTP.new(url.host, url.port)
    http.request_get(url.path) do |remote_file|
      write_to_file_named(filename) do |file_on_server|
        remote_file.read_body do |segment|
          file_on_server.write segment
        end
      end
    end
  rescue Errno::ECONNREFUSED
    raise InvalidURL.new('Veuillez spécifier un URL existant!')
  rescue URI::InvalidURIError
    raise InvalidURL.new('Veuillez spécifier un URL valide!')
  end

  def ensure_is_pdf(filename)
    raise WrongFileFormat.new('Le fichier doit être un PDF!') unless File.extname(filename) == '.pdf'
  end

  def write_to_file_named(filename, &block)
    filename_without_extension = File.basename(filename, '.*')
    exact_timestamp = Time.now.to_f.to_s.sub('.', '')
    server_filename = "#{filename_without_extension}_#{exact_timestamp}.pdf"

    File.open("files/inputs/#{server_filename}", 'wb', &block)
    session[:file] = {
      original_filename: filename,
      server_filename: server_filename
    }
  end

  class EtsHoraireException < Exception; end
  class WrongFileFormat < EtsHoraireException; end
  class InvalidURL < EtsHoraireException; end
end