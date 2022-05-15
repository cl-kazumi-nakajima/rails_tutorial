FactoryBot.define do
  factory :user do
    name { "Michael Example" }
    email { "michael@example.com" }
    # password_digest { User.digest('password') } # FactoryBotでは不要
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
