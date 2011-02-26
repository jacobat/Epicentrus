class TweetstatsController < ApplicationController
  def index
    render :json => Tweetstat.new(2.days.ago.localtime..Time.now.localtime).run
  end
end
