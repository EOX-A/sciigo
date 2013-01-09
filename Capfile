#
# TODO
# * configure a deploy user via puppet and distribute a ssh key
#

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# application settings
set :application, "sciigo"
#set :user, "deploy"
set :use_sudo, false
set :keep_releases, 2
set :copy_exclude, [".git", "Capfile", "*.sublime-project", "*.sublime-workspace", "logs/*", "tmp/*", ".gitignore", "features/*"]

# ssh options
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false

# repository settings
set :repository, "git@gitlab.eox.at:marko.locher/sciigo.git"
set :branch, "production"
set :git_shallow_clone, 1

# Put the app in this directory
set :deploy_to, "/opt/#{application}"
set :deploy_via, :remote_cache

# where should we deploy to?
server "nix.eox.at", :app

# this tells capistrano what to do when you deploy
namespace :deploy do

  desc <<-DESC
  A macro-task that updates the code and fixes the symlink.
  DESC
  task :default do
    transaction do
      update_code
      create_symlink
    end
  end

  task :update_code, :except => { :no_release => true } do
    on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
  end

  task :after_deploy do
    cleanup
  end

end
