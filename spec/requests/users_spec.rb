require 'rails_helper'

RSpec.describe "Users", type: :request do

  let!(:user_michael) {create(:user_michael)}

  describe "GET /signup to users#new" do
    it "should get new" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users to users#index" do
    it "should redirect index when not logged in" do
      get users_path
      expect(response).to redirect_to login_url
    end
  end

  describe "GET /users/:id/following" do
    it "should redirect following when not logged in" do
      get following_user_path(user_michael)
      assert_redirected_to login_url
    end
  end

  describe "GET /users/:id/followers" do
    it "should redirect followers when not logged in" do
      get followers_user_path(user_michael)
      assert_redirected_to login_url
    end
  end

end
