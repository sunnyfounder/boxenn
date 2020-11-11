require 'dry/initializer'

require 'homebrew/errors'

module Homebrew
  class Repository

    extend Dry::Initializer

    option :primary_key, default: -> { self.class.__primary_key__ }, type: method(:Array)

    option :source, default: -> { nil }

    define_method(:find_by_identity) do |**keyword_args|
      keywords = keyword_args.keys
      raise ::Homebrew::InvalidPrimaryKey.new(class_name: self.class.name, provided: keywords, required: primary_key) unless (keywords - primary_key | primary_key - keywords).empty?

      pk_hash = keyword_args.slice(*primary_key)
      source.find_by(pk_hash)
    end

    # def find_by_identity(id:)
    #   source.find_by(id: id)
    # end

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
