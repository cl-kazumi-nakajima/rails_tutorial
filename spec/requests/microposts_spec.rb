require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let!(:micropost) { create(:micropost) }

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
end
