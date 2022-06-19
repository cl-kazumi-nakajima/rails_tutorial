require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  let(:user_michael) { create(:user_michael) }
  let(:user_archer) { create(:user_archer) }

  describe "GET /users/edit" do
    it "unsuccessful edit" do
      log_in_as(user_michael)
      get edit_user_path(user_michael)
      expect(response).to have_http_status(200)
      assert_template 'users/edit'

      patch user_path(user_michael), params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
      assert_template 'users/edit'

      assert_select "#error_explanation > div", text: "The form contains 4 errors."
    end

    it 'successful edit with friendly forwarding' do
      get edit_user_path(user_michael)
      expect(session[:forwarding_url]).not_to eq('')
      log_in_as(user_michael)
      assert_redirected_to edit_user_url(user_michael)
      name  = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(user_michael), params: { user: { name:  name,
                                                email: email,
                                                password:              "",
                                                password_confirmation: "" } }
      assert_not flash.empty?
      assert_redirected_to user_michael
      user_michael.reload
      assert_equal name, user_michael.name
      assert_equal email, user_michael.email

      expect(session[:forwarding_url]).to be_blank
    end

    it "should redirect edit when not logged in" do
      get edit_user_path(user_michael)
      assert_not flash.empty?
      assert_redirected_to login_url
    end
  
    it "should redirect update when not logged in" do
      patch user_path(user_michael), params: { user: { name: user_michael.name,
                                                email: user_michael.email } }
      assert_not flash.empty?
      assert_redirected_to login_url
    end

    it "should redirect edit when logged in as wrong user" do
      log_in_as(user_archer)
      get edit_user_path(user_michael)
      assert flash.empty?
      assert_redirected_to root_url
    end
  
    it "should redirect update when logged in as wrong user" do
      log_in_as(user_archer)
      patch user_path(user_michael), params: { user: { name: user_michael.name,
                                                email: user_michael.email } }
      assert flash.empty?
      assert_redirected_to root_url
    end
  end
end
