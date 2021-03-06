class TwitterSearch

  def initialize(tag, time_interval)
    @tag = tag
    @time_interval = time_interval
    @search = Twitter::Search.new.containing(@tag).per_page(100)
  end

  def cache_filename
    "#{Rails.root}/db/tweets-#{@tag}.yml"
  end

  def fetch
    tweets = []
    if(File.exist?(cache_filename))
      tweets = YAML::load_file(cache_filename)
    end
    tweets.select{|tweet| @time_interval.include?(Time.parse(tweet['created_at']))}
  end

  def latest(count)
    fetch.sort{|a, b| Time.parse(b['created_at']) <=> Time.parse(a['created_at'])}.first(count)
  end

  def run_update
    update(fetch).tap do |tweets|
      File.open(cache_filename, 'w') do |f| YAML::dump(tweets, f) end
    end
  end

  def max_id(tweets)
    tweets.collect{|tweet| tweet['id']}.max
  end

  def update(tweets)
    tweets = tweets + @search.since_id(max_id(tweets)).fetch
    while(@search.next_page?)
      tweets = tweets + @search.fetch_next_page
    end
    tweets
  end

end
