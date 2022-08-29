require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user_michael) { create(:user_michael) }
  let(:user_archer) { create(:user_archer) }
  let(:relationship) { create(:relationship, follower: user_michael, followed: user_archer) }

  it "should be valid" do
    expect(relationship).to be_valid
  end

  it "should require a follower_id" do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
  end

  it "should require a followed_id" do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end
end
