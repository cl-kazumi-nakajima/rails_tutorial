require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let!(:user_michael) { create(:user_michael) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "password resets" do
    it "GET /password_resets/new" do
      get new_password_reset_path
      assert_template 'password_resets/new'
      assert_select 'input[name=?]', 'password_reset[email]'
    end

    describe "POST /password_resets" do
      it "メールアドレスが無効" do
        post password_resets_path, params: { password_reset: { email: "" } }
        assert_not flash.empty?
        assert_template 'password_resets/new'
      end

      it "メールアドレスが有効" do
        post password_resets_path, params: { password_reset: { email: user_michael.email } }
        expect(user_michael.reset_digest).not_to eq(user_michael.reload.reset_digest)
        assert_equal 1, ActionMailer::Base.deliveries.size
        assert_not flash.empty?
        assert_redirected_to root_url
      end
    end

    describe "パスワード再設定フォームのテスト" do
      before do
        post password_resets_path, params: { password_reset: { email: user_michael.email } }
        # controllerで生成したインスタンス変数をテストで参照する
        @user = assigns(:user)
      end

      describe "GET /password_resets/edit" do
        it "メールアドレスが無効" do
          get edit_password_reset_path(@user.reset_token, email: "")
          assert_redirected_to root_url
        end
  
        it "無効なユーザー" do
          @user.toggle!(:activated)
          get edit_password_reset_path(@user.reset_token, email: @user.email)
          assert_redirected_to root_url
        end
  
        it "メールアドレスが有効で、トークンが無効" do
          get edit_password_reset_path('wrong token', email: @user.email)
          assert_redirected_to root_url
        end
  
        it "メールアドレスもトークンも有効" do
          get edit_password_reset_path(@user.reset_token, email: @user.email)
          assert_template 'password_resets/edit'
          assert_select "input[name=email][type=hidden][value=?]", @user.email
        end
      end

      describe "PATCH /password_resets" do
        it "無効なパスワードとパスワード確認" do
          patch password_reset_path(@user.reset_token),
                params: { email: @user.email,
                          user: { password:              "foobaz",
                                  password_confirmation: "barquux" } }
          assert_select 'div#error_explanation'
        end
  
        it "パスワードが空" do
          patch password_reset_path(@user.reset_token),
                params: { email: @user.email,
                          user: { password:              "",
                                  password_confirmation: "" } }
          assert_select 'div#error_explanation'
        end
  
        it "有効なパスワードとパスワード確認" do
          patch password_reset_path(@user.reset_token),
                params: { email: @user.email,
                          user: { password:              "foobaz",
                                  password_confirmation: "foobaz" } }
          assert is_logged_in?
          assert_not flash.empty?
          assert_redirected_to @user
          expect(@user.reload.reset_digest).to eq(nil)
        end
      end
    end
  end

  it "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: user_michael.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /Password reset has expired/i, response.body
  end
end
