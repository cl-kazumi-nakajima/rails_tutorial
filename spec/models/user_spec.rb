require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user_michael) { create(:user_michael) }
  let!(:user_archer) { create(:user_archer) }

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                password: "foobar", password_confirmation: "foobar")
  end

  it "should be valid" do
    expect(@user.valid?).to be_truthy
  end

  it "name should be present" do
    @user.name = '      '
    expect(@user.valid?).not_to be_truthy
  end

  it "email should be present" do
    @user.email = '      '
    expect(@user.valid?).not_to be_truthy
  end

  it "name should not be too long" do
    @user.name = "a" * 51
    expect(@user.valid?).not_to be_truthy
  end

  it "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    expect(@user.valid?).not_to be_truthy
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user.valid?).not_to be_truthy, "#{valid_address.inspect} should be valid"
    end
  end

  it "umail addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user.valid?).not_to be_truthy
  end

  it "email addresses shoudl be saves as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    expect(mixed_case_email.downcase).to eq(@user.reload.email)
  end

  it "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    expect(@user.valid?).not_to be_truthy
  end

  it "password should be minumum length" do
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user.valid?).not_to be_truthy
  end

  it "authenticated? should return false for a user with nil digest" do
    expect(@user.authenticated?(:remember, '')).not_to be_truthy
  end

  it "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    expect { @user.destroy }.to change { Micropost.count }.from(1).to(0)
  end

  it "should follow and unfollow a user" do
    expect(user_michael.following.include?(user_archer)).to be false
    user_michael.follow(user_archer)
    expect(user_michael.following.include?(user_archer)).to be true
    expect(user_archer.followers.include?(user_michael)).to be true
    user_michael.unfollow(user_archer)
    expect(user_michael.following.include?(user_archer)).to be false
  end

  describe "feed should have the right posts" do
    let!(:user_michael) { create(:user_michael) }
    let!(:user_archer) { create(:user_archer) }
    let!(:user_lana) { create(:user_lana) }
    let!(:micropost1) { create(:micropost_orange, user: user_michael) }
    let!(:micropost2) { create(:micropost_tau_manifesto, user: user_archer) }
    let!(:micropost3) { create(:micropost_cat_video, user: user_lana) }
    let!(:relationship1) { create(:relationship, follower: user_michael, followed: user_lana) }

    it do
      # フォローしているユーザーの投稿を確認
      user_lana.microposts.each do |post_following|
        expect(user_michael.feed.include?(post_following)).to be_truthy
      end
      # 自分自身の投稿を確認
      user_michael.microposts.each do |post_self|
        expect(user_michael.feed.include?(post_self)).to be_truthy
      end
      # フォローしていないユーザーの投稿を確認
      user_archer.microposts.each do |post_unfollowed|
        expect(user_michael.feed.include?(post_unfollowed)).to be_falsy
      end
    end
  end
end
