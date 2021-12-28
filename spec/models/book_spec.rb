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

  describe "Book#bonus" do
    context "lucky?がtrueのとき" do
      it "チェキが返ること" do
        book = Book.new
        allow(book).to receive(:lucky?).and_return(true)  # lucky のスタブ化
        # 確認するメソッド呼び出しを実行する前に書く
        expect(book).to receive(:lucky?) # lucky をモックとして扱う
        expect(book.bonus).to eq("著者サイン入りチェキ")

        # スタブ
        #    受信メッセージのテストに使う
        #    テストで注目しているオブジェクトが依存するものを、決まりきった動きしかしない偽物に置き換え、テストの合否が注目しているオブジェクト実装の正しさだけに依存するようにして、検証するために使う
        # モック
        #    送信メッセージのテストに使う
        #    オブジェクトが副作用のあるメッセージを送信するとき、適切な引数・回数で送信しているか、引数の検証や回数の検証に使う
        #    メッセージの受け手を偽物にすり替えておき、この偽物にメッセージの引数や呼び出し回数が想定通りか検証させる、そのためのモック
      end
    end
  end

  describe "Book#take_pictures" do
    context "呼び出しすとき" do
      it "例外が投げられること" do
        book = Book.new
        expect{ book.take_pictures }.to raise_error(RuntimeError, "写真撮影はご遠慮ください")
      end
    end
  end

  it do
    travel_to(Time.current) do
      p Time.current # ブロック中では時間が進まない
      sleep 3
      p Time.current
    end
  end
end
