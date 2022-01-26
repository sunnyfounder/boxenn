FactoryBot.define do
  factory :entity_allowance, class: '::Receipt::Entities::Allowance' do
    allowance_no { '1234567890' }
    amount { 20 }
    create_time { Time.zone.now.to_datetime }
    items { [{ name: '蘋果', unit: '顆', quantity: 1, price: 20, amount: 20, tax_type: :need }] }

    skip_create
    initialize_with { new(attributes) }
  end
end
