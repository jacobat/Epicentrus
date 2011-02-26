class TweetstatsController < ApplicationController
  def index
    expires_in(0, :public => true)
    if(stale?(:etag => Tweet.latest, :last_modified => Tweet.latest.created_at.utc, :public => true))
      render :json => Tweetstat.new(2.days.ago.localtime..Time.now.localtime).run
    end
  end
end
