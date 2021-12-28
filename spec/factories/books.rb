FactoryBot.define do
  factory :book do
    title { "MyString" }
    author { "MyString" }
  end

  trait :with_variations do
    after(:create) do |book|
      book.variations.create!(kind: "paper book")
      # （動作未確認）上のafterメソッドの代わりに、関連先のFactoryBotがあればこう書ける。
      # こちらだとFactoryBot.build時に関連先もbuildで作成できるかも。
      # FactoryBot.create_list(:variation, 2, book: book)
    end
  end
end
