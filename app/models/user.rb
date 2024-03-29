class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  # フォローしているユーザーを配列の様に扱えるようになる
  # followeds は英単語としておかしい。「following配列の元はfollowed idの集合である」ということを明示的にしてる
  has_many :following, through: :active_relationships, source: :followed
  # こちらは source を省略できる（Railsが「followers」を単数形にして自動的に外部キーfollower_idを探してくれるから）
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token # 仮想属性

  # before_save { self.email = email.downcase }
  # リスト 6.34:もう１つのコールバック処理の実装方法
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password # オブジェクト生成時に存在性を検証(新しくレコードが追加されたときだけに適用される)
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 敢えて、複数のクラスメソッド定義方法を用いている(9.4)
  # 1. User.xxx
  # 2. self.xxx   # selfにすると、VSCodeで定義ジャンプできる
  # 3. class << self
  #      def xxx

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  # remember_tokenをユーザーと関連付け、remember_tokenに対応するremember_digestをデータベースに保存
  def remember
    self.remember_token = User.new_token # ローカル変数ではないので self をつける
    update_attribute(:remember_digest, User.digest(self.remember_token)) # バリデーションを素通りさせる(特定の属性のみ更新させたい場合に検証を回避する)
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    # remember_digestは、self.remember_digestと同じ
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    # self.update_attribute とも書けるが、self はモデル内では必須ではない
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)

    # update_columnsは、モデルのコールバックやバリデーションが実行されない点がupdate_attributeと異なる
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    # 第一段階
    # memo: following_ids = following.map(&:id)
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)   # 非効率

    # 第二段階
    # following_ids = "SELECT followed_id FROM relationships
    #                   WHERE follower_id = :user_id"
    # Micropost.where("user_id IN (#{following_ids})
    #                   OR user_id = :user_id", user_id: id)

    # 第三段階:left_outer_join を使う
    part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
    Micropost.left_outer_joins(user: :followers)
              .where(part_of_feed, { id: id }).distinct
              .includes(:user, image_attachment: :blob)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    email.downcase!
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
