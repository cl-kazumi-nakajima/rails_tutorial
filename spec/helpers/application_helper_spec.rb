require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "full title helper" do
    assert_equal full_title, "Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
  end
end
