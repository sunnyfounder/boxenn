# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint(8)        not null, primary key
#  custom_serial_number :string
#  total_amount         :integer
#  receipt_no           :string
#  random_number        :string
#  print                :boolean
#  remark               :string
#  customer_info        :jsonb
#  device_info          :jsonb
#  donate_info          :jsonb
#  items                :jsonb            is an Array
#  created_at           :datetime         not null
#  updated_at           :datetime         not null

module Receipt
  module Models
    class Receipt < ApplicationRecord
      has_many :allowances, dependent: :destroy
    end
  end
end
