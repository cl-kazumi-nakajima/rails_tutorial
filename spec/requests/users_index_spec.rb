require 'rails_helper'

RSpec.describe "Users", type: :request do

  # TDOO: RSpec用に書き直す

  let!(:user) {create(:user_michael)}
  let!(:other_user) { create(:user_archer) }

  describe "GET /signup" do
    it "should get new" do
      get signup_path
      assert_response :success
    end
  end

  describe "GET /users" do
    it "should redirect index when not logged in" do
      get users_path
      assert_redirected_to login_url
    end
  end
    
  describe "PUT /users/edit" do
    it "should redirect edit when not logged in" do
      get edit_user_path(user)
      assert_not flash.empty?
      assert_redirected_to login_url
    end
  
    it "should redirect update when not logged in" do
      patch user_path(user), params: { user: { name: user.name,
                                                email: user.email } }
      assert_not flash.empty?
      assert_redirected_to login_url
    end
  
    it "should redirect edit when logged in as wrong user" do
      log_in_as(other_user)
      get edit_user_path(user)
      assert flash.empty?
      assert_redirected_to root_url
    end
  
    it "should redirect update when logged in as wrong user" do
      log_in_as(other_user)
      patch user_path(user), params: { user: { name: user.name,
                                                email: user.email } }
      assert flash.empty?
      assert_redirected_to root_url
    end
  end

  describe "DELETE /users" do
    it "should redirect destroy when not logged in" do
      assert_no_difference 'User.count' do
        delete user_path(user)
      end
      assert_redirected_to login_url
    end
  
    it "should redirect destroy when logged in as a non-admin" do
      log_in_as(other_user)
      assert_no_difference 'User.count' do
        delete user_path(user)
      end
      assert_redirected_to root_url
    end
  end
end
