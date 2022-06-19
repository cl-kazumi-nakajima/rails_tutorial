require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_user' do
    let(:user_michael) { create(:user_michael) }

    before do
      remember(user_michael)
    end

    it "returns right user when session is nil" do
      expect(current_user).to eq user_michael
      expect(is_logged_in?).to be_truthy
    end
  
    # ユーザーの記憶ダイジェストが記憶トークンと正しく対応していない場合に現在のユーザーがnilになるかどうか
    it "returns nil when remember digest is wrong" do
      # ランダムなトークンをremember_digestにセットする
      user_michael.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
