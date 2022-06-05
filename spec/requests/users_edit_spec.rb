require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user2) }

  describe "GET /users/edit" do
    it "unsuccessful edit" do
      log_in_as(user)
      get edit_user_path(user)
      expect(response).to have_http_status(200)
      assert_template 'users/edit'

      patch user_path(user), params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
      assert_template 'users/edit'

      assert_select "#error_explanation > div", text: "The form contains 4 errors."
    end

    it 'successful edit with friendly forwarding' do
      get edit_user_path(user)
      expect(session[:forwarding_url]).not_to eq('')
      log_in_as(user)
      assert_redirected_to edit_user_url(user)
      name  = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(user), params: { user: { name:  name,
                                                email: email,
                                                password:              "",
                                                password_confirmation: "" } }
      assert_not flash.empty?
      assert_redirected_to user
      user.reload
      assert_equal name, user.name
      assert_equal email, user.email

      expect(session[:forwarding_url]).to be_blank
    end

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
      log_in_as(user2)
      get edit_user_path(user)
      assert flash.empty?
      assert_redirected_to root_url
    end
  
    it "should redirect update when logged in as wrong user" do
      log_in_as(user2)
      patch user_path(user), params: { user: { name: user.name,
                                                email: user.email } }
      assert flash.empty?
      assert_redirected_to root_url
    end
  end
end
