class MessageReceipt < ApplicationRecord
  belongs_to :message

  enum :status, { PENDING: "PENDING", DELIVERED: "DELIVERED", FAILED: "FAILED" }

  validates :status, presence: true
  validates :address, presence: true, uniqueness: { scope: :message_id }
end
