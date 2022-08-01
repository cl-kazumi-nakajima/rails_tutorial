FactoryBot.define do
  factory :user_michael, class: 'User' do
    name { "Michael Example" }
    email { "michael@example.com" }
    # password_digest { User.digest('password') } # FactoryBotでは不要
    password {"foobar"}
    password_confirmation {"foobar"}
    admin {true}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :user_archer, class: 'User' do
    name { "Sterling Archer" }
    email { "duchess@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :user_lana, class: 'User' do
    name { "Lana Kane" }
    email { "hands@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :user_malory, class: 'User' do
    name { "Malory Archer" }
    email { "boss@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :user_no_activated, class: 'User' do
    name { "User No Activated" }
    email { "no@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
    activated {false}
    activated_at {nil}
  end

  factory :user, class: 'User' do
    sequence(:name) { |i| "User_#{i}" }
    sequence(:email) { |i| "user-#{i}@example.com" }
    password {"foobar"}
    password_confirmation {"foobar"}
    activated {true}
    activated_at {Time.zone.now}

    # user create時に、:with_posts を指定すれば実行される
    trait :with_posts do
      after(:create) { |user| create_list(:micropost, 31, user: user) }
    end
  end
end
