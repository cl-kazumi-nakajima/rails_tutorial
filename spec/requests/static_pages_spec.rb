require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /home" do
    it "returns http success" do
      get "/static_pages/home"
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Ruby on Rails Tutorial Sample App')
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get "/static_pages/help"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get "/static_pages/about"
      expect(response).to have_http_status(:success)
    end
  end

end
