class Tweetstat

  def initialize(time_interval)
    @time_interval = time_interval
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
      TwitterSearch.new(tag, (2.days.ago.localtime..Time.now.localtime)).run_update
    end
  end

  def group_tweets(tweets)
    group_by_time(tweets, interval).map{|time, tweets|
      {
        :time   => time,
        :reach  => tweets.group_by{|tweet| tweet.from_user}.length,
        :impact => tweets.length
      }
    }
  end

  def time_round(time)
    Time.at((time.to_i / interval) * interval)
  end

  def pad_tweets(tweets)
    timestamps = tweets.map{|tweet| tweet[:time]}
    min_time = time_round(@time_interval.first)
    max_time = time_round(@time_interval.last)
    steps = (max_time - min_time) / interval
    tweets + (0..steps).map{ |step|
      min_time + step * interval
    }.reject{|timestamp|
      timestamps.include?(timestamp)
    }.map{|timestamp|
      {
        :time   => timestamp,
        :reach  => 0,
        :impact => 0
      }
    }
  end

  def interval
    60.minutes
  end

  def map_tweets(tweets)
    pad_tweets(group_tweets(tweets)).sort_by{|group| group[:time] }
  end

  def run
    output = {}
    hashtags.map do |hashtag|
      search = TwitterSearch.new(hashtag, @time_interval)
      output[hashtag] = map_tweets(search.fetch)
    end
    output
  end
  
end