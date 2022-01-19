require 'dry-struct'
require_relative '../initializer/dry_types'

require 'boxenn/errors'

module Boxenn
  class Entity < Dry::Struct
    alias assign_attributes new

    def self.primary_keys
      raise UndefinePrimaryKeys.new(class_name: self.class.name)
    end

    def primary_keys_hash
      if self.class.primary_keys.all? { |s| attributes.key? s }
        attributes.slice(*self.class.primary_keys)
      else
        raise UnassignPrimaryKeys.new(class_name: self.class.name)
      end
    end
  end
end
