FactoryBot.define do
  factory :user_michael, class: 'User' do
    name { "Michael Example" }
    email { "michael@example.com" }
    # password_digest { User.digest('password') } # FactoryBotでは不要
    password {"foobar"}
    password_confirmation {"foobar"}
    admin {true}
  end

  factory :user_archer, class: 'User' do
    name { "Sterling Archer" }
    email { "duchess@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
  end

  factory :user_lana, class: 'User' do
    name { "Lana Kane" }
    email { "hands@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
  end

  factory :user_malory, class: 'User' do
    name { "Malory Archer" }
    email { "boss@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
  end

  factory :user, class: 'User' do
    sequence(:name) { |i| "User_#{i}" }
    sequence(:email) { |i| "user-#{i}@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
