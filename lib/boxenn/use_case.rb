require 'ostruct'
require 'dry/monads/all'
require 'wisper'
require 'dry/initializer'

module Boxenn
  class UseCase
    extend Dry::Initializer
    include Wisper::Publisher
    include Dry::Monads
    include Dry::Monads::Do

    def call(*args)
      Success(yield(steps(*args)))
    rescue Dry::Monads::Do::Halt
      raise
    rescue StandardError => e
      Failure.new(e, trace: e.backtrace.first)
    end

    protected

    def steps
      raise NotImplementedError
    end
  end
end
