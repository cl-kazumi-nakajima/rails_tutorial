FactoryBot.define do
  factory :micropost_orange, class: 'Micropost' do
    content { "I just ate an orange!" }
    created_at { 10.minutes.ago }
    association :user
  end

  factory :micropost_tau_manifesto, class: 'Micropost' do
    content { "Check out the @tauday site by @mhartl: https://tauday.com" }
    created_at { 3.years.ago }
    association :user
  end

  factory :micropost_cat_video, class: 'Micropost' do
    content { "Sad cats are sad: https://youtu.be/PKffm2uI4dk" }
    created_at { 2.hours.ago }
    association :user
  end

  factory :micropost_most_recent, class: 'Micropost' do
    content { "Writing a short test" }
    created_at { Time.zone.now }
    association :user
  end

  factory :micropost, class: 'Micropost' do
    content { Faker::Lorem.sentence(word_count: 5) }
    created_at { 42.days.ago }
    association :user
  end

  factory :micropost_ants, class: 'Micropost' do
    content { "Oh, is that what you want? Because that's how you get ants!" }
    created_at { 2.years.ago }
    association :user
  end

  factory :micropost_zone, class: 'Micropost' do
    content { "Danger zone!" }
    created_at { 3.days.ago }
    association :user
  end

  factory :micropost_tone, class: 'Micropost' do
    content { "I'm sorry. Your words made sense, but your sarcastic tone did not." }
    created_at { 10.minutes.ago }
    association :user
  end

  factory :micropost_van, class: 'Micropost' do
    content { "Dude, this van's, like, rolling probable cause." }
    created_at { 4.hours.ago }
    association :user
  end
end
