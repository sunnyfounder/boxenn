require 'dry/initializer'

module Boxenn
  module Repositories
    class Query

      extend Dry::Initializer

      param :relation, default: proc { nil }

      def collect
        raise NotImplementedError
      end
    end
  end
end
