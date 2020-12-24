require 'dry/initializer'

module Boxenn
  module Repositories
    class SourceWrapper

      extend Dry::Initializer

      param :source, default: proc { nil }

      def find_by(primary_keys)
        raise NotImplementedError
      end

      def save(primary_keys, attributes)
        raise NotImplementedError
      end
    end
  end
end
