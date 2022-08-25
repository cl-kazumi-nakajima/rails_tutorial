require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user_michael) { create(:user_michael) }
  let!(:user_archer) { create(:user_archer) }

  before do
    @relationship = Relationship.new(follower_id: user_michael.id,
                                      followed_id: user_archer.id)
  end

  it "should be valid" do
    expect(@relationship).to be_valid
  end

  it "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship).not_to be_valid
  end

  it "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship).not_to be_valid
  end
end
