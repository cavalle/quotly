set :application, "Quotes"
set :deploy_via, :copy
set :copy_strategy, :export
set :deploy_to, "~/app"
set :user, "quotes"
set :use_sudo, false
# set :repository,  "set your repository location here"

# set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.2.103"                          # Your HTTP server, Apache/etc
role :app, "192.168.2.103"                          # This may be the same as your `Web` server
role :db,  "192.168.2.103", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task(:start) {}
  task(:stop) {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run " touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end