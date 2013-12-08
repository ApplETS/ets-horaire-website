require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/partial'
require 'rack-flash'
require 'haml'
require 'sass'
require 'compass'
require_relative 'app/helpers/flash_helper'

class EtsHoraire < Sinatra::Base
  register Sinatra::AssetPack
  register Sinatra::Partial
  use Rack::Flash
  helpers FlashHelper

  enable :sessions
  enable :partial_underscores
  set :session_secret, 'Never underestimate the power of the Schwartz!'
  set :root, File.dirname(__FILE__)
  set :views, 'app/views'

  assets do
    serve '/images', from: 'app/assets/images'
    serve '/js', from: 'app/assets/javascripts'
    serve '/css', from: 'app/assets/stylesheets'
    css_compression :sass

    js :application, %w(
      /js/jquery-1.10.2.min.js
      /js/handlebars-v1.1.2.js
      /js/add-period.js
    )

    css :application, %w(
      /css/style.css
    )
  end
end

require_relative 'app/routes/select_file'
require_relative 'app/routes/compute_schedule'