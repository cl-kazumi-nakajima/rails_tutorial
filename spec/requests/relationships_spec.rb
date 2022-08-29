require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:user_michael) { create(:user_michael) }
  let!(:user_lana) { create(:user_lana) }
  let!(:relationship1) { create(:relationship, follower: user_michael, followed: user_lana) }

  it "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  it "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationship1)
    end
    assert_redirected_to login_url
  end
end
