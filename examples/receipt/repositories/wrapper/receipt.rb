module Receipt
  module Repositories::Wrapper
    class Receipt < Boxenn::Repositories::ActiveRecordSourceWrapper
      param :source, default: -> { ::Receipt::Models::Receipt }

      def save(primary_keys, attributes)
        record = source.find_or_initialize_by(primary_keys)
        record.assign_attributes(attributes.except(:allowances))
        record.save!
        record.reload
        save_allowances(record, attributes[:allowances])
      end

      def destroy(primary_keys)
        record = find_by(primary_keys)
        record.destroy!
      end

      def find_by(hash)
        return nil if hash.blank?

        source.find_by(hash)
      end

      private

      def save_allowances(record, allowances)
        allowances.each do |allowance|
          allowance[:receipt_id] = record.id
          primary_keys = allowance.slice(*::Receipt::Entities::Allowance.primary_keys)
          ::Receipt::Repositories::Wrapper::Allowance.new.save(primary_keys, allowance)
        end
      end
    end
  end
end
