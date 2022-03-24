require "rails_helper"

RSpec.describe Post, type: :request do
  context "when not signed" do
    let!(:post_new) { Post.create(title: "First Post", body: "This is first post") }

    it "when show a post" do
      headers = {"ACCEPT" => "application/json"}
      get "/posts/#{post_new.id}.json", headers: headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["title"]).to eq("First Post")
    end

    it "when show posts" do
      headers = {"ACCEPT" => "application/json"}
      get "/posts.json", headers: headers

      expect(response).to have_http_status(:unauthorized)
    end

    it "when creates a post" do
      headers = {"ACCEPT" => "application/json"}
      post "/posts.json", params: {post: {title: "Second Post", body: "This is second post"}}, headers: headers

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "when signed" do
    before(:each) do
      user = User.create(email: "test@test.com", password: "password", password_confirmation: "password") ## uncomment if not using FactoryBot
      sign_in user
    end

    let!(:post_new) { Post.create(title: "First Post", body: "This is first post") }

    it "when creates a post" do
      headers = {"ACCEPT" => "application/json"}
      post "/posts.json", params: {post: {title: "Second Post", body: "This is second post"}}, headers: headers

      expect(response).to have_http_status(:created)
    end

    it "when edits a post" do
      headers = {"ACCEPT" => "application/json"}
      put "/posts/#{post_new.id}.json", params: {post: {title: "Second Post [FIXED]"}}, headers: headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["title"]).to eq("Second Post [FIXED]")
    end

    it "when delete a post" do
      headers = {"ACCEPT" => "application/json"}
      delete "/posts/#{post_new.id}.json", headers: headers

      expect(response).to have_http_status(:no_content)
    end
  end
end
