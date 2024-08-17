require "rails_helper"

RSpec.describe EmailEnqueuerService, type: :service do
  let(:message) { Message.create(title: "Test Subject", body: "Test Content") }

  after do
    Message.destroy_all
  end

  describe "#initialize" do
    it "initializes with a valid Message model" do
      expect { EmailEnqueuerService.new(message, []) }.not_to raise_error
    end

    it "raises an error when the message is not a Message model" do
      message_mock = instance_double("Message")

      expect {
        EmailEnqueuerService.new(message_mock, [])
      }.to raise_error(ArgumentError, an_instance_of(String))
    end
  end

  describe "#enqueue_jobs" do
    let(:emails) { [ "first@example.com", "second@example.com" ] }

    it "calls the SendEmailJob with the correct params" do
      expect(SendEmailJob).to receive(:perform_async).with(message.id, "first@example.com").ordered
      expect(SendEmailJob).to receive(:perform_async).with(message.id, "second@example.com").ordered

      EmailEnqueuerService.new(message, emails).enqueue_jobs
    end
  end
end
