require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let!(:user_michael) { create(:user_michael) }
  let!(:micropost) { create(:micropost) }
  let!(:micropost_ants) { create(:micropost_ants) }

  it "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  it "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to login_url
  end

  it "should redirect destroy for wrong micropost" do
    log_in_as(user_michael)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost_ants)
    end
    assert_redirected_to root_url
  end
end
