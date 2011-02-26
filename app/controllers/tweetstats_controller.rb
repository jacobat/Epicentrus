class TweetstatsController < ApplicationController
  def index
    render :json => Tweetstat.new.run
  end
end
