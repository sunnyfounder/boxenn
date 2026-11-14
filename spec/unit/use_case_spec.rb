require 'boxenn/use_case'

RSpec.describe Boxenn::UseCase do
  context 'when steps takes keyword arguments' do
    let(:use_case) do
      Class.new(described_class) do
        def steps(name:, count: 1)
          Success("#{name}x#{count}")
        end
      end.new
    end

    it 'passes keyword arguments through' do
      expect(use_case.call(name: 'a', count: 2).value!).to eq('ax2')
    end

    it 'does not convert a positional hash into keywords (Ruby 3 semantics)' do
      expect(use_case.call({ name: 'a' })).to be_failure
    end
  end

  context 'when steps takes a positional hash' do
    let(:use_case) do
      Class.new(described_class) do
        def steps(params)
          Success(params.fetch(:name))
        end
      end.new
    end

    it 'passes the hash through' do
      expect(use_case.call({ name: 'a' }).value!).to eq('a')
    end
  end

  context 'when steps raises' do
    let(:use_case) do
      Class.new(described_class) do
        def steps
          raise ArgumentError, 'boom'
        end
      end.new
    end

    it 'wraps the error in a Failure' do
      result = use_case.call
      expect(result).to be_failure
      expect(result.failure.first).to be_a(ArgumentError)
    end
  end
end
