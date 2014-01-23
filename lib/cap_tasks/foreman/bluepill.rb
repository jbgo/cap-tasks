Capistrano::Configuration.instance(true).load do
  after "deploy:update_code", "foreman:export"

  namespace :foreman do

    desc "Export app processes to bluepill format"
    task :export do
      foreman_export_opts = {
        app: fetch(:application),
        log: "#{shared_path}/log",
        env: nil,
        port: nil,
        user: fetch(:user),
        template: nil,
        concurrency: nil,
        procfile: nil,
        root: nil
      }

      foreman_env_path = "config/deploy/#{stage}.env"
      if File.exists?(foreman_env_path)
        foreman_export_opts[:env] = "#{release_path}/#{foreman_env_path}"
      end

      foreman_args = []

      foreman_export_opts.each do |opt, default|
        cap_setting = :"foreman_#{opt}"
        if exists? cap_setting
          foreman_args << "--#{opt} #{fetch(cap_setting)}"
        elsif default
          foreman_args << "--#{opt} #{default}"
        end
      end

      location = fetch :foreman_location, release_path

      run <<-CMD
        cd #{release_path} && \
        rvmsudo foreman export bluepill #{location} #{foreman_args.join(" ")}
      CMD
    end

  end
end
