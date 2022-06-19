require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "should redirect index when not logged in" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end
end
