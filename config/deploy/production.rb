set :stage, :production
set :rvm_ruby_version, 'ruby-1.9.3-p484@ets-horaire'

server 'krystosterone.com', user: 'deploy', roles: %w{web app}, primary: true