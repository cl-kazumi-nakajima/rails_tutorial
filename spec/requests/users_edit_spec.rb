require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/edit" do
    it "unsuccessful edit" do
      get edit_user_path(user)
      expect(response).to have_http_status(200)
      assert_template 'users/edit'

      patch user_path(user), params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
      assert_template 'users/edit'

      assert_select "#error_explanation > div", text: "The form contains 4 errors."
    end
  end
end
