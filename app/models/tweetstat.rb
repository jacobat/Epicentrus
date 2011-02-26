class Tweetstat

  def print_result(result)
    return unless result
    result.each do |r|
      puts "#{r.from_user};#{r.created_at}"
    end
  end

  def group_by_time(tweets, time_interval)
    tweets.group_by { |tweet|
      Time.at((Time.parse(tweet.created_at).to_i / (time_interval)) * time_interval)
    }
  end

  def epicenters
    YAML::load_file("#{Rails.root}/config/epicenters.yml")
  end

  def hashtags
    epicenters.map do |epicenter| epicenter['tag'] end
  end

  def update_all
    hashtags.each do |tag|
      TwitterSearch.new(tag).run_update
    end
  end

  def map_tweets(tweets)
    group_by_time(tweets, 60.minutes).map{|time, tweets|
      number_of_authors = tweets.group_by{|tweet| tweet.from_user}.length
      number_of_tweets = tweets.length
      {
        :time   => time,
        :reach  => number_of_authors,
        :impact => number_of_tweets
      }
    }.sort_by{|group| group[:time] }
  end

  def run
    hashtags.map do |hashtag|
      search = TwitterSearch.new(hashtag)
      { hashtag => map_tweets(search.fetch) }
    end
  end
  
end