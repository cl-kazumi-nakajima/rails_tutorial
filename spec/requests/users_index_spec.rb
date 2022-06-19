require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user_michael) {create(:user_michael)}
  describe "GET /users" do
    before do
      30.times do
        create(:user)
      end
      log_in_as(user_michael)
      get users_path
    end

    it "div.paginationが上下に1つずつ存在すること" do
      expect(response.body.scan('<div role="navigation" aria-label="Pagination" class="pagination">').length).to eq(2)
    end

    it "ユーザーごとのリンクが存在すること" do
      User.paginate(page: 1).each do |user|
        expect(response.body).to include "<a href=\"#{user_path(user)}\">"
      end
    end
  end
end
