class TweetstatsController < ApplicationController
  def index
    expires_in(1.minutes, :public => true)
    render :json => Tweetstat.new(2.days.ago.localtime..Time.now.localtime).run
  end
end
