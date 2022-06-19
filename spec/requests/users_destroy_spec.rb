require 'rails_helper'

RSpec.describe "UsersDestroy", type: :request do
  # ここで作成しておくために ! 付けている
  # そうしないと、実行時に作られてそれを検知されテストが失敗する
  let!(:user_admin) { create(:user_michael) }
  let!(:user_non_admin) { create(:user_archer) }

  describe "DELETE /users/destroy" do
    context 'adminユーザでログインしていない場合' do
      it "should redirect destroy when not logged in" do
        expect {
          delete user_path(user_admin)
        }.to_not change(User, :count)
  
        expect(response).to redirect_to login_path
      end

      it "should redirect destroy when logged in as a non-admin" do
        log_in_as(user_non_admin)
        expect {
          delete user_path(user_admin)
        }.to_not change(User, :count)
          
        expect(response).to redirect_to root_url
      end
    end

    context 'adminユーザでログイン済みの場合' do
      it "ユーザーを削除したらユーザーが1件減ること" do
        log_in_as(user_admin)
        expect {
          delete user_path(user_non_admin)
        }.to change(User, :count).by -1
      end
    end
  end
end
