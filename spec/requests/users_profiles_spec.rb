require 'rails_helper'

RSpec.describe "UsersProfiles", type: :request do
  let!(:user) { create(:user, :with_posts) }

  it "profile display" do
    get user_path(user)
    assert_template 'users/show'
    assert_select 'title', full_title(user.name)
    assert_select 'h1', text: user.name
    assert_select 'h1>img.gravater'
    assert_match user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  it "count relationships" do
    get user_path(user)
    # count だと Integer なのでマッチしない
    assert_select 'strong#following', text: user.following.count.to_s
    assert_select 'strong#followers', text: user.following.count.to_s
  end
end
