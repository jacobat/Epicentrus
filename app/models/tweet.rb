class Tweet < ActiveRecord::Base
  serialize :data
  
  class << self

    def hashtags
      epicenters.map do |epicenter| epicenter['tag'] end
    end

    def update_all
      hashtags.each do |tag|
        update(tag)
      end
    end

    private

    def epicenters
      YAML::load_file("#{Rails.root}/config/epicenters.yml")
    end

    def update(tag)
      search = Twitter::Search.new.containing(tag).per_page(100).since_id(max_id(tag))
      puts "Fetching first page"
      import(search.fetch, tag)
      while(search.next_page?)
        puts "Fetching next page"
        import(search.fetch_next_page, tag)
      end
    end

    def max_id(tag)
      self.where(:hashtag => tag).maximum(:twitter_id)
    end

    def import(tweets, tag)
      tweets.each do |tweet|
        create!(:data => tweet, :twitter_id => tweet.id, :hashtag => tag, :created_at => tweet.created_at)
      end
    end
  end
end
