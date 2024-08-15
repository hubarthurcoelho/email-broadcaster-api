class MessageReceipt < ApplicationRecord
  belongs_to :message

  validates :status, presence: true
  validates :address, presence: true
  validates :delivered_at, presence: false
  validates :address, uniqueness: { scope: :message_id }
end
