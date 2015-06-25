set :application, 'scheduler'
set :repo_url, 'git@github.com:ApplETS/ets-horaire-website.git'

set :branch, :master

set :deploy_to, -> { "/var/www/#{fetch(:application)}.clubapplets.ca" }
# set :scm, :git

set :format, :pretty
set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system files/pdfs db/courses/production}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 2

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:legacy_restart'
      execute :chmod, "-R g+rwx #{current_path}"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
