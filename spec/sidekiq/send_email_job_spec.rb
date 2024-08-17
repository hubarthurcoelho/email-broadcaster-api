require "test_helper"
require 'sidekiq/testing'

RSpec.describe SendEmailJob, type: :job do
  let(:subject) { "Test Subject" }
  let(:content) { "Test Content" }
  let(:message) { Message.create(title: subject, body: content) }

  before do
    Sidekiq::Testing.inline!
  end

  after do
    MessageReceipt.destroy_all
    Message.destroy_all
    Sidekiq::Testing.fake!
  end

  describe '#perform' do
    context 'success' do
      before do
        allow_any_instance_of(MailService).to receive(:send).and_return({ body: "success", error: nil })
      end

      it 'calls MailService with the correct params' do
        address = "test@example.com"

        expect_any_instance_of(MailService).to receive(:send).with(to_email: address, subject: subject, content: content)

        SendEmailJob.perform_async(message.id, address)
      end

      it 'generates the correct receipt for the message' do
        address = "test_the_second@example.com"

        SendEmailJob.perform_async(message.id, address)

        receipt = MessageReceipt.last
        expect(receipt.message_id).to eq(message.id)
        expect(receipt.address).to eq(address)
        expect(receipt.status).to eq("DELIVERED")
        expect(receipt.delivered_at).not_to be_nil
      end
    end

    context 'failure' do
      before do
        allow_any_instance_of(MailService).to receive(:send).and_return({ body: nil, error: "An error occurred" })
      end

      it 'updates the receipt with the apropriate status' do
        address = "test_the_third@example.com"

        SendEmailJob.perform_async(message.id, address)

        receipt = MessageReceipt.last
        expect(receipt.status).to eq("FAILED")
      end

      it 'logs the error' do
        address = "test_the_fourth@example.com"
        err_msg = an_instance_of(String)

        expect(Rails.logger).to receive(:error).with(err_msg)

        SendEmailJob.perform_async(message.id, address)
      end
    end
  end
end
