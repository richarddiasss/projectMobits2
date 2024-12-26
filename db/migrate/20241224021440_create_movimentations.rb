class CreateMovimentations < ActiveRecord::Migration[8.0]
  def change
    create_table :movimentations do |t|
      t.decimal :value
      t.decimal :tax
      t.string :description
      t.integer :account_number

      t.timestamps
    end

    add_foreign_key :movimentations, :accounts, column: :account_number, primary_key: :number
    add_index :movimentations, :account_number
  end
end
