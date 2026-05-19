class AddRoomAndAuthorToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :room, null: true, foreign_key: true
    add_reference :transactions, :author, null: true, foreign_key: { to_table: :users }
  end
end
