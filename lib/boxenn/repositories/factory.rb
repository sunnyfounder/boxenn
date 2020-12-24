require 'dry/initializer'

module Boxenn
  module Repositories
    class Factory

      extend Dry::Initializer

      param :entity, default: proc { nil }

      def build
        raise NotImplementedError
      end

      def primary_keys
        entity.primary_keys
      end
    end
  end
end
