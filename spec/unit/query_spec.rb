require 'boxenn/query'

RSpec.describe Boxenn::Query do

  describe '#collect' do
    let(:query) { Boxenn::Query.new }

    context 'when collect is not override' do
      subject { -> { query.collect } }

      context 'raise not implemented error' do
        it { is_expected.to raise_error(NotImplementedError) }
      end
    end
  end
end
