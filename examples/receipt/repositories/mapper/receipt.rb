module Receipt
  module Repositories::Mapper
    class Receipt < MapperExtenstion
      private

      def map
        {
          custom_serial_number: :custom_serial_number,
          total_amount: :total_amount,
          receipt_no: :receipt_no,
          random_num: :random_number,
          print: :print,
          remark: :remark,
          customer_info: :customer_info,
          device_info: :device_info,
          donate_info: :donate_info,
          items: :items,
          allowances: [
            :allowances,
            allowance_map,
          ],
        }
      end

      def allowance_map
        {
          allowance_no: :allowance_no,
          amount: :amount,
          create_time: :create_time,
          items: :items,
        }
      end
    end
  end
end
