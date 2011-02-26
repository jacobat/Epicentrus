class TweetsController < ApplicationController
  def show
    render :json => TwitterSearch.new("#" + params[:id]).latest(10)
  end
end
