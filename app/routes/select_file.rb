# encoding: UTF-8

require 'net/http'

class Application < Sinatra::Base
  get '/' do
    haml :'select_file/index'
  end

  post '/' do
    begin
      ensure_has_specified_file
      filename = upload_file_to_server
      session[:filename] = filename
      redirect '/horaire'
    rescue EtsHoraireException => e
      # log the error
      flash[:error] = e.message
      haml :'select_file/index'
    rescue Exception => e
      # log the error
      raise e
    end
  end

  private

  def ensure_has_specified_file
    raise NoFileSpecified.new('Veuillez spécifier un fichier!') unless file_from_computer? || file_from_url?
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
    filename = file_from_computer[:filename]
    ensure_is_pdf filename

    write_to_file_named(filename) do |file_on_server|
      file_on_server.write file_from_computer[:tempfile].read
    end
  end

  def upload_file_from_link
    url_of_file = params['input-link']
    filename = File.basename(url_of_file)
    ensure_is_pdf filename

    url = URI.parse(url_of_file)
    write_to_file_named(filename) do |file_on_server|
      Net::HTTP.new(url.host, url.port).request_get(url.path) do |remote_file|
        remote_file.read_body do |segment|
          file_on_server.write segment
        end
      end
    end

  rescue URI::InvalidURIError
    raise InvalidURL.new('Veuillez spécifier un URL valide!')
  end

  def ensure_is_pdf(filename)
    raise WrongFileFormat.new('Le fichier doit être un PDF!') unless File.extname(filename) == '.pdf'
  end

  def write_to_file_named(filename)
    filename_without_extension = File.basename(filename, '.*')
    exact_timestamp = Time.now.to_f.to_s.sub('.', '')
    server_filename = "#{filename_without_extension}_#{exact_timestamp}.pdf"

    File.open("tmp/files/#{server_filename}", 'wb') do |file_on_server|
      yield file_on_server
    end
    filename_without_extension
  end

  class EtsHoraireException < Exception; end
  class NoFileSpecified < EtsHoraireException; end
  class WrongFileFormat < EtsHoraireException; end
  class InvalidURL < EtsHoraireException; end
end