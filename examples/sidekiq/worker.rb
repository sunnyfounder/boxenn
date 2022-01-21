module Boxenn
  module Worker
    # include Sidekiq::Worker when this class is included.
    def self.included(base)
      base.send(:include, Sidekiq::Worker)
    end

    def perform(*params)
      result = if params.empty?
                 call
               else
                 call(serialize(*params))
               end
      return if result.success?

      # error handling when use case was failed.
      # you can do something like throw errors to third party service, e.g. rollbar
      # or sending message to slack and emil.
      message = Array(result.failure).map(&:to_s).join(', ')
      Rollbar.error(message, trace: message)
      # Becareful if you don't raise error when use case was failed,
      # sidekiq will treat it as successed,
      # it will not go to dead queue or retry.
      raise StandardError, message
    end

    private

    # serialize parameters to symbol keys because sidekiq will change parameters to string keys
    def serialize(params)
      params.transform_keys(&:to_sym)
    end
  end
end
