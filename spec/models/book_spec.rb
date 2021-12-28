require 'rails_helper'

RSpec.describe Book, type: :model do
  it "trueであるとき、falseになること" do # itの後にNG時に表示される "説明文" を書く
    expect(true).to eq(true)
    # expect(テスト対象コード).to マッチャー(想定テスト結果)
    # マッチャーとはマッチ(一致)するかを判定する道具です
    # マッチャーはここでは==で一致判定するeqをつかっています
  end

  it "Bookモデルをnewしたとき、nilではないこと" do
    expect(Book.new).not_to eq(nil)
    expect(Book.new).not_to be_nil  # 上と同じ
  end

  # describe: 区切りの単位
  # context: 状況の単位(When) XXの時〜
  #   describe の中に複数書かれる
  # it: (expect) XXであること

  describe "Book#title_with_author" do # describeメソッドをつかってメソッドごとに区切ると読みやすいです
    before do
      @book = Book.new(title: "RubyBook", author: "matz")
    end

    it "Book#title_with_authorを呼び出したとき、titleとauthorを結んだ文字列が返ること" do
      # book = Book.new(title: "RubyBook", author: "matz")  # before に移動
      # binding.irb # debugしたい時に止められる
      expect(@book.title_with_author).to eq("RubyBook - matz")
    end

    # subject を使う例 (あまり使わない？)
    # テスト対象を明示的にする
    subject { Book.new(title: "RubyBook", author: "matz") }
    it "Book#title_with_authorを呼び出したとき、titleとauthorを結んだ文字列が返ること" do
      expect(subject.title_with_author).to eq("RubyBook - matz")
    end

    # subject に名前をつけられる
    context "Book#titleがnilのとき" do
      subject(:book){ Book.new(author: "matz") } # subjectにbookと名前をつける
      it "空のtitleとauthorを結んだ文字列が返ること" do
        expect(book.title_with_author).to eq(" - matz") # bookはBook.new(author: "matz")を指す
      end
    end

    # let, let! : 変数を書く道具
    # subjectは「テスト対象である」ことを含んでいましたがlet, let!にはその意味はありません
    # letをつかうな派も、let!をつかうな派もいる
    context "Book#titleが文字列のとき" do
      let(:book){ Book.new(title: "RubyBook", author: "matz") }
      it "titleとauthorを結んだ文字列が返ること" do
        expect(book.title_with_author).to eq("RubyBook - matz")
      end
    end
  end
end
