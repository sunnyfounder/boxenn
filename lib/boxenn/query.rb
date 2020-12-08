require 'dry/initializer'

module Boxenn
  class Query

    extend Dry::Initializer

    param :relation, default: proc { nil }

    def collect
      raise NotImplementedError
    end
  end
end
