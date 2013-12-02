# encoding: UTF-8

require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/partial'
require 'sinatra/flash'
require 'haml'
require 'sass'
require 'compass'
require 'ostruct'
require 'net/http'
require 'pp'

class Application < Sinatra::Base
  register Sinatra::AssetPack
  register Sinatra::Partial
  register Sinatra::Flash

  enable :sessions
  set :views, 'app/views'

  assets do
    serve '/images', from: 'app/assets/images'
    serve '/js', :from => 'app/assets/javascripts'
    serve '/css', :from => 'app/assets/stylesheets'
    css_compression :sass

    js :application, %w(
      /js/handlebars-v1.1.2.js
      /js/add-period.js
    )

    css :application, %w(
      /css/style.css
    )
  end

  get '/' do
    haml :select_file
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
        haml :select_file
    rescue Exception => e
      # log the error
      raise e
    end
  end

  get '/horaire' do
    simple_filters = [
      OpenStruct.new(name: "Nombre de cours minimum", slug: "minimum-number-of-courses"),
      OpenStruct.new(name: "Nombre de cours maximum", slug: "minimum-number-of-maximum")
    ]
    output_types = [
      OpenStruct.new(source: "simple_list", name: "Liste simple", slug: "output-simple-list"),
      OpenStruct.new(source: "ascii_calendar", name: "Calendrier ASCII", slug: "output-ascii-calendar"),
      OpenStruct.new(source: "html_calendar", name: "Calendrier HTML", slug: "output-html-calendar")
    ]
    haml :compute_schedule, locals: { filename: 'logiciel_e13', courses: %w(LOG121 MAT145 COM110), simple_filters: simple_filters, output_types: output_types }
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
    server_filename
  end

  class EtsHoraireException < Exception; end
  class NoFileSpecified < EtsHoraireException; end
  class WrongFileFormat < EtsHoraireException; end
  class InvalidURL < EtsHoraireException; end

  run! if app_file == $0
end