namespace :app do
  desc 'Update twitter data'
  task :update_twitter => :environment do
    Tweetstat.new(nil).update_all
  end
end
