module Boxenn
  class InvalidPrimaryKey < StandardError
    def initialize(**args)
      super(_message(**args))
    end

    private

    def _message(class_name:, provided:, required:)
      if (required - provided)
        "Primary Key #{required - provided} is missing for class #{class_name.inspect}"
      else
        "#{provided - required} is not a primary key for class #{class_name.inspect}"
      end
    end
  end

  class UndefinePrimaryKeys < StandardError
    def initialize(**args)
      super(_message(**args))
    end

    private

    def _message(class_name:)
      "Primary Key needs to be defined in #{class_name.inspect}"
    end
  end

  class UnassignPrimaryKeys < StandardError
    def initialize(**args)
      super(_message(**args))
    end

    private

    def _message(class_name:)
      "Primary Key needs to be assigned in #{class_name.inspect}"
    end
  end
end
