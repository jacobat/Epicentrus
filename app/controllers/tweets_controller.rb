class TweetsController < ApplicationController
  def show
    render :json => Tweet.where(:hashtag => "#" + params[:id]).order('created_at desc').first(10)
  end
end
