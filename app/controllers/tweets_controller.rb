class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show edit update]
  def index
    @tweets = Tweet.where(parent_id: nil).order(created_at: :desc)
  end

  def show
    @replies = @tweet.children.order(created_at: :asc)
  end
  def new
    @tweet = Tweet.new(parent_id: params[:parent_id])
  end

  def create
    @tweet = Tweet.new(tweet_params)

    if @tweet.save
      redirect_to(@tweet.parent || root_path, notice: "Tweet posted")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Tweet.find(params[:id]).destroy
    redirect_to root_path, notice: "Tweet deleted!"
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end
  def tweet_params
    params.expect(tweet: [ :body, :featured_image, :parent_id ])
  end
end
