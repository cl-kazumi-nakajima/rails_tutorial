require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user_michael) { create(:user_michael, reset_token: User.new_token) }

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user_michael) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user_michael.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user_michael) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["michael@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Password reset")
      expect(mail.body.encoded).to match(user_michael.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(user_michael.email))
    end
  end

end
