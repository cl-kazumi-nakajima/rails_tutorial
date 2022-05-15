require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /signup" do
    it "works! (now write some real specs)" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /user" do
    it "invalid signup information" do
      assert_no_difference 'User.count' do
        post users_path, params: { user: { name: "",
            email: "user@invalid",
            password:              "foo",
            password_confirmation: "bar"
          }
        }
      end
      # assert は minitest の書き方なので、RSpecらしく書こう
      expect(response).to render_template('users/new')
      assert_includes 'div#error_explanation', 'div', 'The form contains 4 errors.'
    end

    it "valid signup information" do
      assert_difference 'User.count' do
        post users_path, params: { user: { name: "foo",
            email: "user@valid.com",
            password:              "foobar",
            password_confirmation: "foobar"
          }
        }
      end
      follow_redirect!
      
      # assert は minitest の書き方なので、RSpecらしく書こう
      # assert_template 'users/show'
      expect(response).to render_template('users/show')

      assert_not flash.empty?

      # assert is_logged_in?
      expect(is_logged_in?).to be_truthy
    end
  end
end
