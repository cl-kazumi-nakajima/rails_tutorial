require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :request do
  let!(:user_michael) { create(:user_michael) }
  let!(:user_malory) { create(:user_malory) }
  let!(:user) { create(:user, :with_posts) }

  describe "マイクロポストのUIに対する統合テスト" do
    it "micropost interface" do
      log_in_as(user)
      get root_path
      assert_select 'div.pagination'
      # 無効な送信
      assert_no_difference 'Micropost.count' do
        post microposts_path, params: { micropost: { content: "" } }
      end
      assert_select 'div#error_explanation'
      assert_select 'a[href=?]', '/?page=2'  # 正しいページネーションリンク
      # 有効な送信
      content = "This micropost really ties the room together"
      assert_difference 'Micropost.count', 1 do
        post microposts_path, params: { micropost: { content: content } }
      end
      assert_redirected_to root_url
      follow_redirect!
      assert_match content, response.body
      # 投稿を削除する
      assert_select 'a', text: 'delete'
      first_micropost = user.microposts.paginate(page: 1).first
      assert_difference 'Micropost.count', -1 do
        delete micropost_path(first_micropost)
      end
      # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
      get user_path(user_michael)
      assert_select 'a', text: 'delete', count: 0
    end

    it "micropost sidebar count" do
      log_in_as(user)
      get root_path
      assert_match "#{user.microposts.paginate(page: 1).count} microposts", response.body
      # まだマイクロポストを投稿していないユーザー
      log_in_as(user_malory)
      get root_path
      assert_match "0 microposts", response.body
      user_malory.microposts.create!(content: "A micropost")
      get root_path
      assert_match "1 micropost", response.body
    end
  end
end
