class CreateMessageReceipts < ActiveRecord::Migration[7.2]
  def change
    create_table :message_receipts do |t|
      t.references :message, null: false, foreign_key: true
      t.string :address
      t.string :status
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
