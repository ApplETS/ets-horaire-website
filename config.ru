require 'sinatra'
require 'bundler/setup'
require './app'

set :run, false
set :raise_errors, true

run Application.new