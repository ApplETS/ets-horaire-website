require 'sinatra/assetpack'
require 'sinatra/partial'
require 'sinatra/flash'
require 'haml'
require 'sass'
require 'compass'

class Application < Sinatra::Base
  register Sinatra::AssetPack
  register Sinatra::Partial
  register Sinatra::Flash

  enable :sessions
  enable :partial_underscores
  set :root, File.dirname(__FILE__)
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
end

require_relative 'app/routes/select_file'
require_relative 'app/routes/compute_schedule'