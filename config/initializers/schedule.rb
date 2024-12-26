# config/initializers/scheduler.rb
require "rufus-scheduler"

return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == "rake"

scheduler = Rufus::Scheduler.new

def log_message(msg)
  puts msg
  Rails.logger.info(msg)
end

scheduler.every "1m" do
  log_message("\n[#{Time.current}] Iniciando verificação de contas com saldo negativo...")

  # Alterado para usar count() ao invés de tentar acessar value_account da collection
  accounts = Account.where(vip: true).where("value_account < 0")
  log_message("[#{Time.current}] Encontradas #{accounts.count} contas VIP com saldo negativo")

  accounts.find_each do |account|
    old_balance = account.value_account
    reduction = (account.value_account.abs * 0.001)
    account.update_column(:value_account, (account.value_account - reduction))

    log_message("[#{Time.current}] Conta #{account.number}: Saldo alterado de #{old_balance} para #{account.value_account}")
  end

  log_message("[#{Time.current}] Verificação finalizada!\n")
end

log_message("[#{Time.current}] Scheduler iniciado com sucesso! Rodando a cada 1 minuto.")
