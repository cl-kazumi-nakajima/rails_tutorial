class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # 以前のRailsのバージョンでは、このバリデーションが必須だったが、Rails 5から必須ではなくなった
  # この手のバリデーションが省略されている可能性があることを頭の片隅で覚えておく
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
