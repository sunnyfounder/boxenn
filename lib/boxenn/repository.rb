require 'dry/initializer'

require 'boxenn/errors'

module Boxenn
  class Repository

    extend Dry::Initializer

    option :source_wrapper, default: -> { nil }

    option :factory, default: -> { nil }

    option :record_mapper, default: -> { nil }

    def find_by_identity(**attributes)
      non_primary_keys_provided = (attributes.keys - factory.primary_keys).empty? && (factory.primary_keys - attributes.keys).empty?
      raise InvalidPrimaryKey.new(class_name: self.class.name, provided: attributes.keys, required: factory.primary_keys) unless non_primary_keys_provided

      record = retrieve_record(attributes)
      record.nil? ? nil : build(record)
    end

    def find_by_query(query)
      records = query.collect
      records.map { |record| build(record) }
    end

    def save(entity)
      attributes = adapt(entity)
      save_record(entity.primary_keys_hash, attributes)
    end

    def destroy(entity)
      source_wrapper.destroy(entity.primary_keys_hash)
    end

    protected

    def retrieve_record(**attributes)
      pk_hash = attributes.slice(*factory.primary_keys)
      record = source_wrapper.find_by(pk_hash)
    end

    def save_record(primary_keys, attributes)
      source_wrapper.save(primary_keys, attributes)
    end

    def build(record)
      factory.build(record)
    end

    def adapt(entity)
      record_mapper.build(entity)
    end
  end
end
