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

    def save(entities)
      Array(entities).each do |entity|
        attributes = adapt(entity.to_h)
        identity = adapt(entity.primary_keys_hash)
        save_record(identity, attributes)
      end
    end

    def destroy(entities)
      Array(entities).each do |entity|
        identity = adapt(entity.primary_keys_hash)
        source_wrapper.destroy(identity)
      end
    end

    protected

    def retrieve_record(**attributes)
      hash = attributes.slice(*factory.primary_keys)
      pk_hash = adapt(hash)
      record = source_wrapper.find_by(pk_hash)
    end

    def save_record(primary_keys, attributes)
      source_wrapper.save(primary_keys, attributes)
    end

    def build(record)
      factory.build(record)
    end

    def adapt(hash)
      record_mapper.build(hash)
    end
  end
end
