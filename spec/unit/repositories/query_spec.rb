require 'boxenn/repositories/query'

RSpec.describe Boxenn::Repositories::Query do
  describe '#collect' do
    let(:query) { Boxenn::Repositories::Query.new }

    context 'when collect is not override' do
      subject { -> { query.collect } }

      context 'raise not implemented error' do
        it { is_expected.to raise_error(NotImplementedError) }
      end
    end
  end
end
