require 'rails_helper'

RSpec.describe "UsersSignup", type: :request do
  describe "GET /signup" do
    it "works! (now write some real specs)" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /user" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "invalid signup information" do
      get signup_path
      assert_no_difference 'User.count' do
        # アクティベート前
        post users_path, params: { user: { name: "",
            email: "user@invalid",
            password:              "foo",
            password_confirmation: "bar"
          }
        }
      end
      expect(response).to render_template('users/new')
      # TODO: assert は minitest の書き方なので、RSpecらしく書こう
      assert_includes 'div#error_explanation', 'div', 'The form contains 4 errors.'
    end

    it "valid signup information" do
      get signup_path
      assert_difference 'User.count' do
        post users_path, params: { user: { name: "foo",
            email: "user@valid.com",
            password:              "foobar",
            password_confirmation: "foobar"
          }
        }
      end
      # TODO: assert は minitest の書き方なので、RSpecらしく書こう
      # 配信されたメッセージがきっかり1つであるかどうかを確認
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      # 有効化していない状態でログインしてみる
      log_in_as(user)
      assert_not is_logged_in?
      # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
      assert_not is_logged_in?
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      assert_not is_logged_in?
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
    end
  end
end
