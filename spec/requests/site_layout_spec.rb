require 'rails_helper'

RSpec.describe "Site Layout", type: :request do
  let!(:user_michael) { create(:user_michael) }
  let!(:user_archer) { create(:user_archer) }

  it "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    get contact_path
    assert_select "title", full_title("Contact")

    get signup_path
    assert_select "title", full_title("Sign up")
  end

  it "logged in" do
    log_in_as(user_michael)
    get users_path
    assert_select "a[href=?]", "/users/#{user_michael.id}", text: user_michael.name
    assert_select "a[href=?]", "/users/#{user_archer.id}", text: user_archer.name
  end
end
