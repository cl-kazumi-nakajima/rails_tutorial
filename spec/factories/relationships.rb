FactoryBot.define do
  factory :relationship, class: Relationship do
    follower_id { follower.id }
    followed_id { followed.id }
  end
end
