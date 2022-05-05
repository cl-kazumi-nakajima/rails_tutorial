require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /home" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Ruby on Rails Tutorial Sample App')
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get help_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Help | Ruby on Rails Tutorial Sample App')
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('About | Ruby on Rails Tutorial Sample App')
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get contact_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Contact | Ruby on Rails Tutorial Sample App')
    end
  end
end
