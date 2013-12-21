set :application, 'ets-horaire'
set :deploy_to, '/var/www/ets-horaire.krystosterone.com'
set :deploy_via, :remote_cache
set :linked_dirs, %w{log tmp/pids tmp/cache}
set :ssh_options, {
    forward_agent: true,
    port: 2244
}
set :use_sudo, false

set :log_level, :debug

set :scm, 'git'
set :repo_url, 'https://github.com/Krystosterone/ets-horaire-website.git'
set :branch, 'master'

set :keep_releases, 5

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: { no_release: true } do
        execute "/etc/init.d/unicorn_ets-horaire #{command}"
      end
    end
  end

  task :setup_config do
    on roles(:app) do
      execute "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/sites-enabled/ets-horaire.krystosterone.com"
      execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_ets-horaire"
    end
  end
  before 'deploy:publishing', 'deploy:setup_config'

  task :setup_folders do
    on roles(:app) do
      rake 'create:folder_structure'
    end
  end
  before 'deploy:publishing', 'deploy:setup_config'

  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end
  before 'deploy', 'deploy:check_revision'
end