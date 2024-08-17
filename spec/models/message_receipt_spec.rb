require 'rails_helper'

RSpec.describe MessageReceipt, type: :model do
  let(:message) { Message.create(title: "Test Subject", body: "Test Content") }
  describe 'validations' do
    it 'is valid with all required attributes' do
      message_receipt = MessageReceipt.new(status: 'PENDING', address: 'test@example.com', message: message)
      expect(message_receipt).to be_valid
    end

    it 'is not valid without a status' do
      message_receipt = MessageReceipt.new(status: nil)
      expect(message_receipt).not_to be_valid
    end

    it 'is not valid without an address' do
      message_receipt = MessageReceipt.new(address: nil)
      expect(message_receipt).not_to be_valid
    end

    it 'is not valid if address is not unique for the same message' do
      MessageReceipt.create(address: 'test@example.com', message: message, status: 'PENDING')
      duplicate_receipt = MessageReceipt.new(address: 'test@example.com', message: message)

      expect(duplicate_receipt).not_to be_valid
    end
  end

  describe 'enum status' do
    it 'raises an error on invalid status transition' do
      message_receipt = MessageReceipt.create(address: 'second_test@example.com', message: message, status: 'PENDING')
      expect { message_receipt.update!(status: 'INVALID') }.to raise_error(ArgumentError)
    end
  end
end
