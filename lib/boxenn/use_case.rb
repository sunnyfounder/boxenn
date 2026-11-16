require 'dry/monads/all'
require 'wisper'
require 'dry/initializer'

module Boxenn
  ##
  # 這個類別是在 Domain(Use case) 層中負責處理業務邏輯的基礎類別

  class UseCase
    extend Dry::Initializer
    include Wisper::Publisher
    include Dry::Monads
    include Dry::Monads::Do

    # 位置參數與關鍵字參數原樣轉給 steps（Ruby 3 起兩者分開，不再自動互轉）
    def call(*, **)
      Success(yield(steps(*, **)))
    rescue Dry::Monads::Do::Halt
      raise
    rescue StandardError => e
      Failure.new([e], trace: e.backtrace.first)
    end

    protected

    def steps
      raise NotImplementedError
    end
  end
end
