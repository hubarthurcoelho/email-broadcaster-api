class MessageReceipt < ApplicationRecord
  belongs_to :message

  validates :status, presence: true
  validates :recipient, presence: true
  validates :delivered_at, presence: true
  validates :recipient, uniqueness: { scope: :message_id }
end
