require 'shared/repository'

RSpec.describe Receipt::Repositories::Receipt do
  it_behaves_like 'a repository' do
    let(:entity) { build_entity }
    let(:identity) { build_identity }
    let(:repo) { described_class.new }
  end

  private

  def build_allowances
    allowance1 = create(
      :entity_allowance,
      allowance_no: 'abc12345678',
      amount: 80,
      items: [{ name: '蘋果', unit: '顆', quantity: 1, price: 80, amount: 80, tax_type: :need }],
    )
    allowance2 = create(
      :entity_allowance,
      allowance_no: 'asd12345679',
      amount: 50,
      items: [{ name: '蘋果', unit: '顆', quantity: 1, price: 50, amount: 50, tax_type: :need }],
    )
    [allowance1, allowance2]
  end

  def build_entity
    create(
      :entity_receipt,
      custom_serial_number: 'ORD2468013579',
      total_amount: 100,
      print: false,
      receipt_no: 'AQ123456',
      items: [{ name: '蘋果', unit: '顆', quantity: 1, price: 100, amount: 100, tax_type: :need }],
      random_num: '1234',
      customer_info: { id: 123, name: '王小明', vat_number: nil, address: '台北市中山區民權西路87號', email: 'abc@gmail.com', phone: '0987654321' },
      device_info: { device_type: :sunnyfounder_device, device_num: '/1234567' },
      donate_info: { donation: false, love_code: nil },
      allowances: build_allowances,
    )
  end

  def build_identity
    {
      custom_serial_number: 'ORD2468013579',
    }
  end
end
