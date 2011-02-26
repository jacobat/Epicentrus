class TweetsController < ApplicationController
  def show
    render :json => Tweet.show(params)
  end
end
