require "rails_helper"

RSpec.describe Message, type: :model do
  describe "validations" do
    it "is valid with a body and an optional title" do
      message = Message.new(title: "Optional Title", body: "This is a valid body")
      expect(message).to be_valid
    end

    it "is valid without a title" do
      message = Message.new(body: "This is a valid body")
      expect(message).to be_valid
    end

    it "is not valid if the title is longer than 50 characters" do
      message = Message.new(title: "a" * 51, body: "This is a valid body")
      expect(message).not_to be_valid
    end

    it "is valid if the title is 50 characters or less" do
      message = Message.new(title: "a" * 50, body: "This is a valid body")
      expect(message).to be_valid
    end

    it "is not valid without a body" do
      message = Message.new(title: "Optional Title", body: nil)
      expect(message).not_to be_valid
    end

    it "is not valid if the body is longer than 500 characters" do
      message = Message.new(title: "Optional Title", body: "a" * 501)
      expect(message).not_to be_valid
    end

    it "is valid if the body is 500 characters or less" do
      message = Message.new(title: "Optional Title", body: "a" * 500)
      expect(message).to be_valid
    end
  end
end
