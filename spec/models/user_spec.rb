require 'rails_helper'

RSpec.describe User, type: :model do
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
    expect(@user.authenticated?('')).not_to be_truthy
  end
end
