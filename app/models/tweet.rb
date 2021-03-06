class Tweet < ActiveRecord::Base
  serialize :data

  scope :with_tag, lambda { |tag| where(:hashtag => tag) }

  after_create :process_image_url
  after_create :attach_image

  validates_uniqueness_of :twitter_id

  has_attached_file :image_attachment, :styles => { :thumb => "100x140#" }

  class << self

    def show(args)
      time = (args[:before].present? ? (Time.at(args[:before].to_i) + 1.hour): Time.now)
      count = (args[:count].present? ? args[:count].to_i : 10)
      where(:hashtag => args[:id]).
        where(["created_at < ?", time]).
        order('created_at desc').
        first(count)
    end

    def latest
      order('created_at DESC').first
    end

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
      puts "Fetching first page for #{tag} since #{max_id(tag)}"
      import(search.fetch, tag)
      while(search.next_page?)
        puts "Fetching next page for #{tag}"
        import(search.fetch_next_page, tag)
      end
    end

    def max_id(tag)
      self.where(:hashtag => tag).maximum(:twitter_id)
    end

    def import(tweets, tag)
      tweets.each do |tweet|
        if create(:data => tweet, :twitter_id => tweet.id, :hashtag => tag, :created_at => tweet.created_at)
        else
          puts "Couldn't create tweet #{tweet.id}"
        end
      end
    end
  end

  def url?
    URI.parse(url)
    true
  rescue URI::InvalidURIError
    false
  end

  def url
      url = data.text.slice(/http:\/\/.*/)
      if url
        url = url.slice(URI.regexp)
      end
      url
    rescue URI::InvalidURIError
  end

  def image?
    url && url.match(/(instagr.am|yfrog.com)/)
  end

  def image_url
    return false unless url
    if(url.match(/yfrog.com/))
      doc = Nokogiri::HTML(open(url.gsub(/.com/, '.com/f')))
      doc.css("#main_image").attribute('src').value
    elsif(url.match(/instagr.am/))
      doc = Nokogiri::HTML(open(url))
      doc.css('.photo').first.attribute('src').value
    else
      false
    end
  end

  def process_image_url
    update_attribute(:image, image_url) if(image.nil?)
  end

  def attach_image
    if(image? && !image_attachment.file?)
      self.image_attachment = open(URI.parse(image))
      self.save
    end
  end

  def as_json(options={})
    if(image_attachment.file?)
      super.merge(:thumbnail => true, :thumb => image_attachment.url(:thumb))
    else
      super.merge(:thumbnail => false)
    end
  end
end
