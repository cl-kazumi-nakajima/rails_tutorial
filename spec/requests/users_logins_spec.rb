require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  # 以下は同じ意味。下の方は省略形(support/factory_bot.rb で、FactoryBotを省略できるようにしてる)
  # @user = FactoryBot.create(:user)
  let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

  describe "GET /login" do
    it "login with valid information followed by logout" do
      get login_path
      assert_template 'sessions/new'

      # login
      post login_path, params: { session: { email: user.email, password: "password" } }
      assert is_logged_in?
      assert_redirected_to user # リダイレクト先のチェック
      follow_redirect!  # リダイレクト先に実際に移動
      assert_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(user)

      # logout
      delete logout_path
      assert_not is_logged_in?
      assert_redirected_to root_url

      # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(user), count: 0
    end

    it "login with invalid information" do
      get login_path
      assert_template 'sessions/new'
      post login_path, params: { session: { email: "", password: "" } }
      assert_template 'sessions/new'
      assert_not flash.empty?
      get root_path
      assert flash.empty?
    end

    it "login with valid email, invalid password" do
      get login_path
      assert_template 'sessions/new'
      post login_path, params: { session: { email: user.email,
                                            password: "invalid" } }
      assert_not is_logged_in?
      assert_template 'sessions/new'
      assert_not flash.empty?
      get root_path
      assert flash.empty?
    end
  end
end
