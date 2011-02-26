class TweetstatsController < ApplicationController
  def index
    if(stale?(:etag => Tweet.latest, :last_modified => Tweet.latest.created_at.utc))
      render :json => Tweetstat.new(2.days.ago.localtime..Time.now.localtime).run
    end
  end
end
