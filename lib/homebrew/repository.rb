require 'dry/initializer'

require 'homebrew/errors'

module Homebrew
  class Repository

    extend Dry::Initializer

    option :primary_key, default: -> { self.class.__primary_key__ }, type: method(:Array)

    option :source, default: -> { nil }

    option :factory, default: -> { nil }

    option :record_mapper, default: -> { nil }

    def find_by_identity(**attributes)
      non_primary_keys_provided = !(attributes.keys - primary_key).empty?
      raise ::Homebrew::InvalidPrimaryKey.new(class_name: self.class.name, provided: attributes.keys, required: primary_key) if non_primary_keys_provided

      record = retrieve_record(attributes)
      build(record)
    end

    def find_by_query(query)
      records = query.collect
      records.map { |record| build(record) }
    end

    def save(entity)
      attributes = adapt(entity)
      save_record(attributes)
    end

    protected

    def retrieve_record(**attributes)
      primary_keys_missing = !(primary_key - attributes.keys).empty?
      raise ::Homebrew::InvalidPrimaryKey.new(class_name: self.class.name, provided: attributes.keys, required: primary_key) if primary_keys_missing

      pk_hash = attributes.slice(*primary_key)
      record = source.find_by(pk_hash)
    end

    def save_record(**attributes)
      source.save(attributes)
    end

    def build(record)
      factory.build(record)
    end

    def adapt(entity)
      record_mapper.build(entity)
    end

    class << self 
      def primary_key(*pk)
        @pk = Array(pk)
      end

      def __primary_key__
        @pk ||= [:id]
      end
    end
  end
end
