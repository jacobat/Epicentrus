require 'bundler/capistrano'

set :application, "epicentrus"
set :repository,  "."
set :deploy_to, "/var/www/#{application}"
set :user, 'epicentrus'
set :scm, :git
set :user, 'epicentrus'
set :use_sudo, false
set :deploy_via, :copy
set :bundle_cmd, '/home/epicentrus/.gem/ruby/1.8/bin/bundle'

role :web, "93.90.116.253"                          # Your HTTP server, Apache/etc
role :app, "93.90.116.253"                          # This may be the same as your `Web` server
role :db,  "93.90.116.253", :primary => true # This is where Rails migrations will run
role :db,  "93.90.116.253"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end