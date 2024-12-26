class AddDefaultToTaxInMovimentations < ActiveRecord::Migration[8.0]
  def change
    change_column_default :movimentations, :tax, 0
  end
end
