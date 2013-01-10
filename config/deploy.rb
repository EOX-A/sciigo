require 'bundler/capistrano'

# application settings
set :application, "sciigo"
set :user, "deploy"
set :use_sudo, false
set :keep_releases, 2
set :copy_exclude, [".git", "Capfile", "*.sublime-project", "*.sublime-workspace", "logs/*", "tmp/*", ".gitignore", "features/*", "*.example"]
set :default_environment, { 'PATH' => '/var/lib/gems/1.8/bin/:$PATH' }
set :normalize_asset_timestamps, false

# ssh options
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false
ssh_options[:compression] = "none"

# repository settings
set :repository, "git@gitlab.eox.at:marko.locher/scriigo.git"
set :branch, "production"

# Put the app in this directory
set :deploy_to, "/opt/#{application}"
set :deploy_via, :remote_cache

# where should we deploy to?
role :app, "nix.eox.at"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# no need to start, stop, ... anything, as this app is only a script called
# by nagios / icinga
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart do ; end
end