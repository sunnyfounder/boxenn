require 'active_job'

module Boxenn
  ##
  # 讓 UseCase（或任何有 #call 的類別）可以丟到背景執行（ActiveJob）。不會自動載入，需要時 `require 'boxenn/job'`。
  #
  #   class SyncProject < Boxenn::UseCase
  #     include Boxenn::Job
  #     job_options queue: :general, retry: false
  #
  #     def steps(project_id:) ... end
  #   end
  #
  #   SyncProject.perform_later(project_id: 1)
  #   SyncProject.set(wait: 5.minutes).perform_later(project_id: 1)
  #
  # include 時會在類別底下建一個 `SyncProject::Job`（繼承 Boxenn::Job.base_class，預設 ActiveJob::Base），
  # 排隊、重試、序列化都交給 ActiveJob。執行時呼叫 `SyncProject.new.call(...)`，參數原樣轉過去
  # （關鍵字參數維持關鍵字參數）；回傳 Failure 時 raise Boxenn::Job::Failed，走重試與失敗紀錄。
  module Job
    class Failed < StandardError; end

    # Sidekiq 的預設重試次數是 25；沒有指定 retry 時沿用，行為跟從 Sidekiq 搬過來之前一樣
    DEFAULT_ATTEMPTS = 26

    class << self
      attr_writer :base_class

      def base_class
        case @base_class
        when nil then ActiveJob::Base
        when String then Object.const_get(@base_class)
        else @base_class
        end
      end
    end

    def self.included(base)
      # 已經有自己的 ::Job（例如父類別 include 過、inherited 已建好）就不重建
      Boxenn::Job.build_job_class(base, Boxenn::Job.base_class) unless base.const_defined?(:Job, false)
      base.extend ClassMethods
      base.send(:attr_accessor, :job_id) unless base.method_defined?(:job_id)
    end

    def self.build_job_class(target, superclass)
      job = Class.new(superclass)
      job.include(Boxenn::Job::Runner) unless job < Boxenn::Job::Runner
      job.target = target
      target.const_set(:Job, job)
    end

    module Runner
      def self.included(job)
        job.class_attribute :target
        job.class_attribute :attempts, default: Boxenn::Job::DEFAULT_ATTEMPTS
        job.class_attribute :discard_when_exhausted, default: false

        job.rescue_from(StandardError) do |error|
          if executions < self.class.attempts
            retry_job wait: retry_wait, error: error
          elsif self.class.discard_when_exhausted
            logger.error("[Boxenn::Job] #{self.class.name} 重試用完，丟棄：#{error.class}: #{error.message}")
          else
            raise error
          end
        end
      end

      def perform(*args, **kwargs)
        use_case = self.class.target.new
        use_case.job_id = job_id
        result = use_case.call(*args, **kwargs)
        return result unless result.respond_to?(:failure?) && result.failure?

        raise Failed, Array(result.failure).map(&:to_s).join(', ')
      end

      private

      # 跟 ActiveJob retry_on 的 :polynomially_longer 一樣（也接近 Sidekiq 的退避）
      def retry_wait
        delay = executions**4
        delay + (delay * 0.15 * rand) + 2
      end
    end

    module ClassMethods
      # 子類別各自有一個 ::Job（繼承父類別的 Job，佇列、重試設定跟著繼承），執行時跑的是子類別
      def inherited(subclass)
        super
        Boxenn::Job.build_job_class(subclass, self::Job)
      end

      # queue：佇列名稱
      # retry：true（預設，重試 25 次）／false（不重試）／整數（重試幾次）
      # dead：false 時重試用完直接丟棄（不留失敗紀錄）
      def job_options(queue: nil, retry: nil, dead: nil)
        self::Job.queue_as(queue) if queue
        self::Job.attempts = attempts_for(binding.local_variable_get(:retry)) unless binding.local_variable_get(:retry).nil?
        self::Job.discard_when_exhausted = (dead == false) unless dead.nil?
      end

      def perform_later(...)
        self::Job.perform_later(...)
      end

      def perform_now(...)
        self::Job.perform_now(...)
      end

      def set(...)
        self::Job.set(...)
      end

      private

      def attempts_for(value)
        case value
        when true then Boxenn::Job::DEFAULT_ATTEMPTS
        when false then 1
        else Integer(value) + 1
        end
      end
    end
  end
end
