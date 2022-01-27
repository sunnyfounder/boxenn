module Receipt
  module Entities
    class Allowance < Boxenn::Entity
      def self.primary_keys
        [:allowance_no]
      end
      # 折讓單號
      attribute :allowance_no,          Types::Coercible::String.optional.default(nil)
      # 折讓總額
      attribute :amount,                Types::Coercible::String.optional.default(nil)

      attribute :items, Types::Array.default([].freeze) do
        # 商品名稱
        attribute :name,       Types::Coercible::String
        # 商品單位
        attribute :unit,       Types::Coercible::String
        # 商品數量
        attribute :quantity,   Types::Coercible::String
        # 商品單價
        attribute :price,      Types::Coercible::String
        # 商品總額
        attribute :amount,     Types::Coercible::String
        # 商品税別, 0: 應稅, 1: 零稅率, 2: 免稅
        attribute :tax_type,
                  Types::Symbol.enum(need: 'need', zero: 'zero', no_need: 'no_need').optional.default(:need)
      end
    end
  end
end
