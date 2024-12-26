# README

Gerenciador de Conta Corrente

Este projeto, desenvolvido em Ruby on Rails, simula um sistema básico de gerenciamento de contas correntes para correntistas com perfis "Normal" e "VIP".

Funcionalidades Principais:

Autenticação: Login com conta corrente e senha.
Consultas: Saldo e extrato detalhado das transações.
Transações: Saque, depósito, transferência entre contas.
Serviços: Solicitação de visita do gerente (exclusivo para VIP).
Taxas: Taxas de transferência e saque diferenciadas por perfil.
Limites: Limites de saque e transferência para usuários normais.
Persistência: Dados armazenados em banco de dados MySQL/Postgres.
Diferenciais:

Perfis de usuário: Funcionalidades e taxas diferenciadas para cada perfil.
Gestão de saldo negativo: Permite saques acima do saldo para usuários VIP, com cobrança de juros.
Histórico de transações: Extrato detalhado com data, hora, valor e descrição.
Tecnologias:

Ruby on Rails
Postgres
HTML, CSS, JavaScript
