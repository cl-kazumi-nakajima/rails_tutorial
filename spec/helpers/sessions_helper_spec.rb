require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_user' do
    let(:user) { create(:user) }

    before do
      remember(user)
    end

    it "returns right user when session is nil" do
      expect(current_user).to eq user
      expect(is_logged_in?).to be_truthy
    end
  
    # ユーザーの記憶ダイジェストが記憶トークンと正しく対応していない場合に現在のユーザーがnilになるかどうか
    it "returns nil when remember digest is wrong" do
      # ランダムなトークンをremember_digestにセットする
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
