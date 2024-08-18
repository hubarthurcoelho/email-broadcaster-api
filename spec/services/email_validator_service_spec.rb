require "rails_helper"

RSpec.describe EmailValidatorService, type: :service do
  describe "#validate" do
    let(:email) { "valid@example.com" }
    let(:invalid_email) { "validexamplecom" }

    it "validates a valid email address" do
      err = EmailValidatorService.new.validate(email)
      expect(err).to be(nil)
    end

    it "invalidates an invalid email address" do
      err = EmailValidatorService.new.validate(invalid_email)
      expect(err).to be_a(String)
    end
  end

  describe "#validate_multiple" do
    let(:emails) { [ "valid@example.com", "second_valid@example.com" ] }
    let(:invalid_emails) { [ "validexample.com", "second_validexamplecom" ] }

    it "validates a valid email addresses" do
      errs = EmailValidatorService.new.validate_multiple(emails)
      expect(errs).to eq([])
    end

    it "returns an array of errors for invalid email addresses" do
      errs = EmailValidatorService.new.validate_multiple(invalid_emails)
      expect(errs).to eq([
        "validexample.com is not a valid email address",
        "second_validexamplecom is not a valid email address"
      ])
    end
  end
end
