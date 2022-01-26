module Receipt
  module Repositories::Wrapper
    class Allowance < Boxenn::Repositories::ActiveRecordSourceWrapper
      param :source, default: -> { ::Receipt::Models::Allowance }

      def save(primary_keys, attributes)
        record = source.find_or_initialize_by(primary_keys)
        record.assign_attributes(attributes)
        record.save!
      end

      def find_by(hash)
        return nil if hash.blank?

        source.find_by(hash)
      end
    end
  end
end
