module Receipt
  module Entities
    class Receipt < Boxenn::Entity
      def self.primary_keys
        [:custom_serial_number]
      end
      # 自訂編號 (identity)
      attribute :custom_serial_number,  Types::Coercible::String
      # 是否列印
      attribute :print,                 Types::Params::Bool.optional.default(false)
      # 發票備註
      attribute :remark,                Types::Coercible::String.optional.default(nil)
      # 發票總額
      attribute :total_amount,          Types::Coercible::String.optional.default(nil)

      attribute :customer_info, Dry::Struct.meta(omittable: true) do
        # 顧客 ID
        attribute :id,                    Types::Coercible::String.optional.default(nil)
        # 顧客名字
        attribute :name,                  Types::Coercible::String.optional.default(nil)
        # 顧客統一編號
        attribute :vat_number,            Types::Coercible::String.optional.default(nil)
        # 顧客地址
        attribute :address,               Types::Coercible::String.optional.default(nil)
        # 顧客email
        attribute :email,                 Types::Coercible::String.optional.default(nil)
        # 顧客電話
        attribute :phone,                 Types::Coercible::String.optional.default(nil)
      end

      attribute :device_info, Dry::Struct.meta(omittable: true) do
        # 載具類型
        attribute :device_type,
                  Types::Symbol.enum(phone_device: 'phone_device', personal_device: 'personal_device').optional.default(nil)
        # 載具編號
        attribute :device_num,            Types::Coercible::String.optional.default(nil)
      end

      attribute :donate_info, Dry::Struct.meta(omittable: true) do
        # 是否捐贈
        attribute :donation,              Types::Params::Bool.default(false)
        # 捐贈碼
        attribute :love_code,             Types::Coercible::String.optional.default(nil)
      end

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

      # 開立後才有的資訊
      # 發票號碼
      attribute :receipt_no,              Types::Coercible::String.optional.default(nil)
      # 隨機碼
      attribute :random_num,              Types::Coercible::String.optional.default(nil)

      # 折讓
      attribute :allowances,              Types::Array.of(Entities::Allowance).default([].freeze)

      def remain_amount
        total_amount.to_i - allowances.inject(0) { |sum, e| sum + e.amount.to_i }
      end

      def add_or_update_allowance(allowance)
        index = allowances.index { |e| e.allowance_no == allowance.allowance_no }
        if index.nil?
          new(allowances: allowances.push(allowance))
        else
          array = allowances
          array[index] = allowance
          new(allowances: array)
        end
      end
    end
  end
end
