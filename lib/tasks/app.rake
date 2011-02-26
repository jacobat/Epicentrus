namespace :app do
  desc 'Update twitter data'
  task :update_twitter => :environment do
    Tweet.update_all
  end
end
