class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts, id: false do |t| # Remove a coluna id padrão
      t.integer :number, primary_key: true # Define 'number' como chave primária
      t.string :name
      t.boolean :vip
      t.string :password_digest
      t.decimal :value_account

      t.timestamps
    end
  end
end
