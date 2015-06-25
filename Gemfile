source 'https://rubygems.org'

gem 'bundler'
gem 'rails', '~> 4.2.1'
gem 'sqlite3'
gem 'sass-rails'
gem 'compass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'hpricot'
gem 'whenever', require: false
gem 'bootstrap-sass', '~> 3.3.5'
gem 'colorize'

gem 'ets_schedule_parser', git: 'https://github.com/Krystosterone/ets_schedule_parser.git', tag: '0.1.0'

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-unicorn', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'selenium-webdriver'
end

group :production do
  gem 'unicorn'
end

group :doc do
  gem 'sdoc', require: false
end