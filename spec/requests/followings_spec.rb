require 'rails_helper'

RSpec.describe "Followings", type: :request do
  let!(:user_michael) { create(:user_michael) }
  let!(:user_lana) { create(:user_lana) }
  let!(:user_malory) { create(:user_malory) }
  let!(:user_archer) { create(:user_archer) }
  let!(:relationship1) { create(:relationship, follower: user_michael, followed: user_lana) }
  let!(:relationship2) { create(:relationship, follower: user_michael, followed: user_malory) }
  let!(:relationship3) { create(:relationship, follower: user_lana, followed: user_michael) }
  let!(:relationship4) { create(:relationship, follower: user_archer, followed: user_michael) }

  before do
    log_in_as(user_michael)
  end

  it "following page" do
    get following_user_path(user_michael)
    expect(user_michael.following).not_to be_empty
    expect(response.body).to include user_michael.following.count.to_s
    user_michael.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  it "followers page" do
    get followers_user_path(user_michael)
    expect(user_michael.followers).not_to be_empty
    expect(response.body).to include user_michael.followers.count.to_s
    user_michael.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
