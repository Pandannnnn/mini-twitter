require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  describe "GET /tweets" do
    it "returns only the main tweets in the index" do
      main_tweet = Tweet.create!(body: "Main tweet")
      reply = Tweet.create!(body: "A reply", parent: main_tweet)
      get tweets_path

      expect(response).to have_http_status(:ok)

      page = response.parsed_body

      tweet_ids = page.css("a.tweet-content-link").map do |link|
        link["href"].split("/").last.to_i
      end

      expect(tweet_ids).to include(main_tweet.id)
      expect(tweet_ids).not_to include(reply.id)
    end
  end

  describe "GET /tweets/:id" do
    it "shows the selected tweet and its direct replies only" do
      main_tweet = Tweet.create!(body: "Main tweet")
      reply = Tweet.create!(body: "A direct reply", parent: main_tweet)
      nested_reply = Tweet.create!(body: "A nested reply", parent: reply)

      get tweet_path(main_tweet)

      expect(response).to have_http_status(:ok)

      page = response.parsed_body

      tweet_ids = page.css("a.tweet-content-link").map do |link|
        link["href"].split("/").last.to_i
      end

      expect(tweet_ids).to include(main_tweet.id)
      expect(tweet_ids).to include(reply.id)
      expect(tweet_ids).not_to include(nested_reply.id)
    end
  end

  describe "POST /tweets" do
    it 'creates a tweet' do
      expect do
        post tweets_path, params: {
          tweet: {
            body: "A new tweet"
          }
        }
      end.to change(Tweet, :count).by(1)

      created_tweet = Tweet.order(:id).last

      expect(created_tweet.body.to_plain_text).to eq("A new tweet")
      expect(created_tweet.parent).to be_nil
      expect(response).to redirect_to(root_path)
    end

    it "creates a reply to an existing tweet" do
      parent_tweet = Tweet.create!(body: "Parent tweet")

      expect do
        post tweets_path, params: {
          tweet: {
            body: "A new reply",
            parent_id: parent_tweet.id
          }
        }
      end.to change(Tweet, :count).by(1)

      created_reply = Tweet.order(:id).last

      expect(created_reply.body.to_plain_text).to eq("A new reply")
      expect(created_reply.parent).to eq(parent_tweet)
      expect(response).to redirect_to(tweet_path(parent_tweet))
    end

    it "does not create an empty tweet" do
      expect do
        post tweets_path, params: {
          tweet: {
            body: ""
          }
        }
      end.not_to change(Tweet, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /tweets/:id" do
    it "updates an existing tweet" do
      tweet = Tweet.create!(body: "Original tweet")

      patch tweet_path(tweet), params: {
        tweet: {
          body: "Updated tweet"
        }
      }

      expect(tweet.reload.body.to_plain_text).to eq("Updated tweet")
      expect(response).to redirect_to(tweet_path(tweet))
    end
  end

  describe "DELETE /tweets/:id" do
    it "deletes an existing tweet" do
      tweet = Tweet.create!(body: "Tweet to delete")

      expect do
        delete tweet_path(tweet)
      end.to change(Tweet, :count).by(-1)

      expect(Tweet.exists?(tweet.id)).to be(false)
      expect(response).to redirect_to(root_path)
    end
  end
end
