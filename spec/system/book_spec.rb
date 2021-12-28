require "rails_helper"

RSpec.describe "books", type: :system do
  it "GET /books" do
    visit "/books" # /booksへHTTPメソッドGETでアクセス
    expect(page).to have_text("Books") # 表示されたページに Books という文字があることを確認
  end

  it "POST /books" do
    visit "/books/new"
    fill_in "Title", with: "RubyBook" # Title入力欄に"RubyBook"を入力する
    fill_in "Author", with: "matz"
    click_button "Create Book" # Create Bookボタンを押す

    expect(page).to have_text("Book was successfully created.")
    expect(page).to have_text("Title: RubyBook")
    expect(page).to have_text("Author: matz")
  end
end
