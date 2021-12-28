FactoryBot.define do
  factory :variation do
    kind { "PDF" }
    book { nil }  # ここに関連を持たせてしまうと、メンテナンスが大変になる(モデルが増えて関連が絡みあってきたときに書きづらくなっていくため)のでやらない。関連付けは、オブジェクト生成時にやる
    # factory定義に関連を書きたい場合にはtraitをつかうのがお勧め
    # spec/factories/books.rb 参照
  end
end
