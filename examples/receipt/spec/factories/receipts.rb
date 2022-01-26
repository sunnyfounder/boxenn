FactoryBot.define do
  factory :entity_receipt, class: 'Receipt::Entities::Receipt' do
    custom_serial_number { 'ABC123456' }
    print { false }
    remark { nil }
    total_amount { 100 }
    receipt_no { nil }
    create_date { nil }
    random_num { nil }
    create_time { nil }
    customer_info do
      { id: 123, name: '王小明', vat_number: nil, address: '台北市中山區民權西路87號', email: 'abc@gmail.com', phone: '0987654321' }
    end
    device_info { nil }
    donate_info { { donation: false, love_code: nil } }
    items { [{ name: '蘋果', unit: '顆', quantity: 1, price: 100, amount: 100, tax_type: :need }] }
    allowances { [] }

    skip_create
    initialize_with { new(attributes) }
  end
end
