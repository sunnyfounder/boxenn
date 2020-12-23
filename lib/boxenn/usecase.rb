require 'ostruct'
require 'dry/monads/all'
require 'wisper'
require 'dry/initializer'

module Boxenn
  class Usecase
    extend Dry::Initializer
    include Wisper::Publisher
    include Dry::Monads
    include Dry::Monads::Do

    def call(*args)
      Success(yield(steps(*args)))
    rescue Dry::Monads::Do::Halt
      raise
    rescue StandardError => e
      Failure(e)
    end

    protected

    def steps
      raise NotImplementedError
    end
  end
end
