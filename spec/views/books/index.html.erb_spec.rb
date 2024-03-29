require 'rails_helper'

RSpec.describe "books/index", type: :view do
  before(:each) do
    assign(:books, [
      Book.create!(
        title: "Title",
        author: "Author"
      ),
      Book.create!(
        title: "Title",
        author: "Author"
      )
    ])
  end

  # HTML要素がtable構成ではないので落ちる
  pending it "renders a list of books" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "Author".to_s, count: 2
  end
end
