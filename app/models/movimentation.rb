class Movimentation < ApplicationRecord
  belongs_to :account, foreign_key: "account_number", primary_key: "number"
end
