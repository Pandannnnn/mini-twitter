require 'rails_helper'

RSpec.describe Tweet, type: :model do
  it "successfully creates a tweet" do
    tweet = Tweet.create(body: "pandan")
    expect(tweet).to be_valid
  end
  it "validates character count" do
    tweet = Tweet.create(body: "a" * 201)
    expect(tweet.errors.full_messages).to include("Body is too long (maximum is 200 characters)")
  end

  it "checks for null body" do
    tweet = Tweet.create(body: nil)
    expect(tweet.errors.full_messages).to include("Body can't be blank")
  end

  it "checks for main tweets only" do
    main_tweet = Tweet.create!(body: "test")
    main_tweet2 =  Tweet.create!(body: "test2")
    children1 = Tweet.create!(body: "test", parent_id: main_tweet.id)
    children2 = Tweet.create!(body: "test3", parent_id: main_tweet2.id)

    expect(Tweet.main_tweets).to include(main_tweet)
    expect(Tweet.main_tweets).to include(main_tweet2)
    expect(Tweet.main_tweets).not_to include(children1)
    expect(Tweet.main_tweets).not_to include(children2)
  end
end
