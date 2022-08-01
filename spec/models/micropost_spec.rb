require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:user_michael) { create(:user_michael) }
  let!(:micropost_orange) { create(:micropost_orange, user: user_michael) }
  let!(:micropost_tau_manifesto) { create(:micropost_tau_manifesto, user: user_michael) }
  let!(:micropost_cat_video) { create(:micropost_cat_video, user: user_michael) }
  let!(:micropost_most_recent) { create(:micropost_most_recent, user: user_michael) }

  it "should be valid" do
    expect(micropost_orange).to be_valid
  end

  it "user id should be present" do
    micropost_orange.user_id = nil
    expect(micropost_orange).not_to be_valid
  end

  it "content should be present" do
    micropost_orange.content = "   "
    expect(micropost_orange).not_to be_valid
  end

  it "content should be at most 140 characters" do
    micropost_orange.content = "a" * 141
    expect(micropost_orange).not_to be_valid
  end

  it "order should be most recent first" do
    expect(micropost_most_recent).to eq(Micropost.first)
  end
end
