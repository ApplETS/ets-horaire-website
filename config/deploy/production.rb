set :stage, :production
set :ruby_version, 'ruby-1.9.3-p484'
set :ruby_gemset, 'ets-horaire'
set :rvm_ruby_version, "#{fetch(:ruby_version)}@#{fetch(:ruby_gemset)}"

server 'krystosterone.com', user: 'deploy', roles: %w{web app}, primary: true