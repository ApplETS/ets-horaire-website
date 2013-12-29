set :application, 'ets-horaire'
set :deploy_to, '/var/www/ets-horaire.krystosterone.com'
set :deploy_via, :remote_cache
set :linked_dirs, %w{log tmp files/pdfs db/courses/production public/assets}
set :ssh_options, {
    forward_agent: true,
    port: 2244
}
set :use_sudo, false
set :pty, true

set :log_level, :debug

set :scm, 'git'
set :repo_url, 'https://github.com/Krystosterone/ets-horaire-website.git'
set :branch, 'master'

set :keep_releases, 3

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: { no_release: true } do
        execute "/etc/init.d/unicorn_ets-horaire #{command}"
      end
    end
  end

  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:web) do
      set :previous_release, release_path

      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end
  before :deploy, 'deploy:check_revision'

  task :create_rvm_gemset do
    on roles(:app) do
      with rails_env: fetch(:stage) do
        execute "/bin/bash -l -c 'cd #{release_path} && rvm #{fetch(:rvm_ruby_version)} --create'"
      end
    end
  end
  before 'bundler:install', 'deploy:create_rvm_gemset'

  task :create_rvm_files do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute "echo \"#{fetch(:ruby_version)}\" > .ruby-version"
          execute "echo \"#{fetch(:ruby_gemset)}\" > .ruby-gemset"
        end
      end
    end
  end
  before 'bundler:install', 'deploy:create_rvm_files'

  task :bundle_install_to_system do
    on roles(:app) do
      with rails_env: fetch(:stage) do
        execute "/bin/bash -l -c 'cd #{release_path} && rvm #{fetch(:rvm_ruby_version)} && bundle install --local'"
      end
    end
  end
  before 'deploy:updated', 'deploy:bundle_install_to_system'

  task :create_tmp_folders do
    on roles(:web) do
      execute "cd #{shared_path.join('tmp')} && ([[ -d cache ]] || mkdir cache) && chmod -R 755 cache"
      execute "cd #{shared_path.join('tmp')} && ([[ -d files ]] || mkdir files) && chmod -R 755 files"
      execute "cd #{shared_path.join('tmp')} && ([[ -d pids ]] || mkdir pids) && chmod -R 755 pids"
      execute "cd #{shared_path.join('tmp')} && ([[ -d sessions ]] || mkdir sessions) && chmod -R 755 sessions"
      execute "cd #{shared_path.join('tmp')} && ([[ -d sockets ]] || mkdir sockets) && chmod -R 755 sockets"
    end
  end
  before 'deploy:updated', 'deploy:create_tmp_folders'

  desc 'Create nginx and unicorn configs'
  task :setup_config do
    on roles(:app) do
      execute "ln -nfs #{release_path}/config/nginx.conf /opt/nginx/sites-enabled/ets-horaire.krystosterone.com"
      execute "ln -nfs #{release_path}/config/unicorn_init.sh /etc/init.d/unicorn_ets-horaire"
    end
  end
  after :updated, 'deploy:setup_config'

  desc 'Run rake tasks needed for proper application deployment'
  task :run_rake_tasks do
    on roles(:app) do
      system "cd #{Dir.pwd} && RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:clean"
      system "cd #{Dir.pwd} && RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      system "cd #{Dir.pwd} && RAILS_ENV=#{fetch(:stage)} bundle exec rake create:folder_structure"
      system "cd #{Dir.pwd} && RAILS_ENV=#{fetch(:stage)} bundle exec rake download_and_store:pdfs_from_etsmtl"
      system "cd #{Dir.pwd} && RAILS_ENV=#{fetch(:stage)} bundle exec rake convert_pdfs:to_json"

      system "cd #{File.join(Dir.pwd, 'public')} && tar -jcf assets.tar.bz2 assets"
      system "cd #{File.join(Dir.pwd, 'files/pdfs')} && tar -jcf pdfs.tar.bz2 *"
      system "cd #{File.join(Dir.pwd, "db/courses/#{fetch(:stage)}")} && tar -jcf courses.tar.bz2 *"

      upload! File.join(Dir.pwd, 'public/assets.tar.bz2'), shared_path.join('public')
      upload! File.join(Dir.pwd, 'files/pdfs/pdfs.tar.bz2'), shared_path.join('files/pdfs')
      upload! File.join(Dir.pwd, "db/courses/#{fetch(:stage)}/courses.tar.bz2"), shared_path.join("db/courses/#{fetch(:stage)}")

      system "rm #{File.join(Dir.pwd, 'public/assets.tar.bz2')}"
      system "rm #{File.join(Dir.pwd, 'files/pdfs/pdfs.tar.bz2')}"
      system "rm -rf #{File.join(Dir.pwd, "db/courses/#{fetch(:stage)}")}"

      execute "/bin/bash -l -c 'cd #{release_path} && rvm #{fetch(:rvm_ruby_version)} && RAILS_ENV=#{fetch(:stage)} bundle exec rake create:folder_structure'"

      execute "cd #{shared_path.join('public')} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
      execute "cd #{shared_path.join('files/pdfs')} && tar -jxf pdfs.tar.bz2 && rm pdfs.tar.bz2"
      execute "cd #{shared_path.join("db/courses/#{fetch(:stage)}")} && tar -jxf courses.tar.bz2 && rm courses.tar.bz2"
    end
  end
  after :updated, 'deploy:run_rake_tasks'

  task :update_whenever do
    on roles(:app) do
      execute("/bin/bash -l -c 'cd #{fetch(:previous_release)} && rvm #{fetch(:rvm_ruby_version)} && RAILS_ENV=#{fetch(:stage)} bundle exec whenever --clear-crontab'")
      execute "/bin/bash -l -c 'cd #{release_path} && rvm #{fetch(:rvm_ruby_version)} && RAILS_ENV=#{fetch(:stage)} bundle exec whenever --update-crontab'"
    end
  end
  after :updated, 'deploy:update_whenever'

  desc 'Restart Nginx'
  task :restart_nginx do
    on roles(:app), except: { no_release: true } do
      execute '/etc/init.d/nginx restart', raise_on_non_zero_exit: false
    end
  end
  after :restart, 'deploy:restart_nginx'
  after :restart, 'deploy:cleanup'
end