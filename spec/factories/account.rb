FactoryBot.define do
  factory :account do
    name { "Richard" }
    number { Random.rand(10000..99999) }
    password { "1234" }
    value_account { 0 }
    vip { false }
  end
end
