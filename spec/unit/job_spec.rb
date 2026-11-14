require 'boxenn/use_case'
require 'boxenn/job'

ActiveJob::Base.queue_adapter = :test
ActiveJob::Base.logger = Logger.new(nil)

module JobSpec
  class Greet < Boxenn::UseCase
    include Boxenn::Job
    job_options queue: :general, retry: 2

    class << self
      attr_accessor :calls
    end

    def steps(name:, fail: false)
      self.class.calls << name
      fail ? Failure(:nope) : Success(name)
    end
  end

  class NoRetry < Boxenn::UseCase
    include Boxenn::Job
    job_options retry: false

    def steps
      Failure(:nope)
    end
  end

  class Parent < Boxenn::UseCase
    include Boxenn::Job
    job_options queue: :report, retry: false

    class << self
      attr_accessor :ran
    end

    def steps
      self.class.ran = [self.class, job_id]
      Success()
    end
  end

  class Child < Parent; end
end

RSpec.describe Boxenn::Job do
  include ActiveJob::TestHelper

  before do
    JobSpec::Greet.calls = []
    clear_enqueued_jobs
  end

  it 'creates a named ActiveJob class under the use case' do
    expect(JobSpec::Greet::Job.name).to eq('JobSpec::Greet::Job')
    expect(JobSpec::Greet::Job.superclass).to eq(ActiveJob::Base)
    expect(JobSpec::Greet::Job.queue_name).to eq('general')
  end

  it 'enqueues with keyword arguments preserved' do
    JobSpec::Greet.perform_later(name: 'a')
    job = enqueued_jobs.last
    expect(job[:job]).to eq(JobSpec::Greet::Job)
    perform_enqueued_jobs
    expect(JobSpec::Greet.calls).to eq(['a'])
  end

  it 'supports set(wait:)' do
    JobSpec::Greet.set(wait: 60).perform_later(name: 'b')
    expect(enqueued_jobs.last[:at]).to be > Time.now.to_f
  end

  it 'retries on Failure up to the configured attempts, then raises' do
    JobSpec::Greet.perform_later(name: 'c', fail: true)
    perform_enqueued_jobs # 第 1 次，失敗後排入重試
    perform_enqueued_jobs # 第 2 次
    expect { perform_enqueued_jobs }.to raise_error(Boxenn::Job::Failed, /nope/) # 第 3 次（retry: 2 用完）
    expect(JobSpec::Greet.calls).to eq(%w[c c c])
  end

  it 'does not retry when retry: false' do
    expect { JobSpec::NoRetry.perform_now }.to raise_error(Boxenn::Job::Failed)
  end

  it 'defaults to Sidekiq-like 25 retries' do
    klass = Class.new(Boxenn::UseCase)
    stub_const('JobSpec::Default', klass)
    klass.include(described_class)
    expect(klass::Job.attempts).to eq(26)
  end

  it 'gives each subclass its own Job that runs the subclass and inherits options' do
    expect(JobSpec::Child::Job.superclass).to eq(JobSpec::Parent::Job)
    expect(JobSpec::Child::Job.queue_name).to eq('report')
    job = JobSpec::Child.perform_later
    perform_enqueued_jobs
    expect(JobSpec::Child.ran).to eq([JobSpec::Child, job.job_id])
  end

  it 're-including in a subclass keeps the subclass Job' do
    klass = Class.new(JobSpec::Parent)
    stub_const('JobSpec::Reincluded', klass)
    job_class = klass::Job
    klass.include(Boxenn::Job)
    expect(klass::Job).to equal(job_class)
  end
end
