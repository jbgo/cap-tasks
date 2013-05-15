Capistrano::Configuration.instance(true).load do
  after "deploy:update_code", "foreman:export"
  after "deploy:restart", "foreman:restart"

  namespace :foreman do
    desc "Install (or update) upstart scripts for services in Procfile."
    task :export, :roles => :worker do
      app_name = fetch(:application)

      foreman_args = [
        "--app #{app_name}",
        "--user #{fetch(:user)}",
        "--env #{release_path}/config/deploy/#{stage}.env",
        "--log #{shared_path}/log"
      ]

      if exists?(:foreman_concurrency)
        foreman_args << "--concurrency #{fetch(:foreman_concurrency)}"
      end

      run <<-CMD
        #{sudo} rm -rf /etc/init/#{app_name}*.conf &&\
        cd #{release_path} &&\
        rvmsudo bundle exec foreman export upstart /etc/init #{foreman_args.join(' ')}
      CMD
    end

    desc "Start services in Procfile."
    task :start, :roles => :worker do
      run "#{sudo} start #{fetch(:app_name)}"
    end

    desc "Stop services in Procfile."
    task :stop, :roles => :worker do
      run "#{sudo} start #{fetch(:app_name)}"
    end

    desc "Restart services in Procfile."
    task :restart, :roles => :worker do
      app_name = fetch(:app_name)
      run "#{sudo} stop #{app_name}; #{sudo} start #{app_name}"
    end
  end
end

