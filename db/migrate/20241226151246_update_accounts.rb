class UpdateAccounts < ActiveRecord::Migration[8.0]
  def change
    # Atualiza a coluna value_account para permitir valores com 2 casas decimais
    change_column :accounts, :value_account, :decimal, precision: 10, scale: 2

    # Define o valor padrão da coluna vip como false
    change_column_default :accounts, :vip, from: nil, to: false
  end
end
