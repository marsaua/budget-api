class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :description, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :kind, null: false, default: "expense"
      t.string :category, null: false, default: "other"
      t.date :occurred_on, null: false

      t.timestamps
    end

    add_index :transactions, :occurred_on
    add_index :transactions, :kind
    add_index :transactions, :category
  end
end
