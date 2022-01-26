module Receipt
  module Repositories
    class Receipt < Boxenn::Repository
      option :source_wrapper, default: -> { Wrapper::Receipt.new }

      option :record_mapper, default: -> { Mapper::Receipt.new }

      option :factory, default: -> { Factory::Receipt.new }
    end
  end
end
