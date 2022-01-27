# == Schema Information
#
# Table name: allowances
#
#  id           :bigint(8)        not null, primary key
#  allowance_no :string
#  amount       :integer
#  receipt_id   :bigint(8)
#  items        :jsonb            is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null

module Receipt
  module Models
    class Allowance < ApplicationRecord
      belongs_to :receipt
    end
  end
end
