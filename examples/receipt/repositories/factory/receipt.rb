module Receipt
  module Repositories::Factory
    class Receipt < Boxenn::Repositories::Factory
      param :entity, default: -> { Entities::Receipt }

      def build(source_object)
        entity.new(
          custom_serial_number: source_object.custom_serial_number,
          print: source_object.print,
          remark: source_object.remark,
          total_amount: source_object.total_amount,
          customer_info: build_customer_info(source_object.customer_info),
          device_info: build_device_info(source_object.device_info),
          donate_info: build_donate_info(source_object.donate_info),
          items: build_items(source_object.items),
          receipt_no: source_object.receipt_no,
          random_num: source_object.random_number,
          allowances: build_allowances(source_object.allowances),
        )
      end

      private

      def build_allowances(allowances)
        allowances.map do |allowance|
          Entities::Allowance.new(
            allowance_no: allowance.allowance_no,
            amount: allowance.amount,
            items: build_items(allowance.items),
          )
        end
      end

      def build_customer_info(data)
        return nil if data.blank?

        data = data.transform_keys(&:to_sym)
        {
          id: data[:id],
          name: data[:name],
          vat_number: data[:vat_number],
          address: data[:address],
          email: data[:email],
          phone: data[:phone],
        }
      end

      def build_device_info(data)
        return nil if data.blank?

        data = data.transform_keys(&:to_sym)
        {
          device_type: data[:device_type],
          device_num: data[:device_num],
        }
      end

      def build_donate_info(data)
        return nil if data.blank?

        data = data.transform_keys(&:to_sym)
        {
          donation: data[:donation],
          love_code: data[:love_code],
        }
      end

      def build_items(data)
        return [] if data.blank?

        data.map do |item|
          item_hash = item.transform_keys(&:to_sym)
          {
            name: item_hash[:name],
            unit: item_hash[:unit],
            quantity: item_hash[:quantity],
            price: item_hash[:price],
            amount: item_hash[:amount],
            tax_type: item_hash[:tax_type],
          }
        end
      end
    end
  end
end
