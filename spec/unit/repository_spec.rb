require 'homebrew/repository'

RSpec.describe Homebrew::Repository do
  let(:repository) { Homebrew::Repository.new(source: source, primary_key: primary_key) }
  let(:source) { spy('source', find_by: nil) }
  let(:primary_key) { [:name] }

  describe '#find_by_identity' do
    context 'when method is called with keywords arguments' do
      subject { -> { repository.find_by_identity(name: 1) } }

      context 'accepts matching primary keys' do
        it { is_expected.not_to raise_error }
      end

      context 'rejects missing primary keys' do
        let(:primary_key) { [] }
        it { is_expected.to raise_error(Homebrew::InvalidPrimaryKey) }
      end

      context 'rejects unnecessary primary keys' do
        let(:primary_key) { [:id, :name] }
        it { is_expected.to raise_error(Homebrew::InvalidPrimaryKey) }
      end
    end

    context 'when matching primary key is set' do

      context 'accepts single primary key' do
        let(:primary_key) { [:name] }

        specify do
          repository.find_by_identity(name: 'Name')
          expect(source).to have_received(:find_by).with(name: 'Name')
        end
      end

      context 'accepts multiple primary key' do
        let(:primary_key) { [:id, :name] }

        specify do
          repository.find_by_identity(id: 1, name: 'Name')
          expect(source).to have_received(:find_by).with(id: 1, name: 'Name')
        end
      end

      context 'accepts not defined and defaults to :id' do
        let(:repository) { Homebrew::Repository.new(source: source) }

        specify do
          repository.find_by_identity(id: 1)
          expect(source).to have_received(:find_by).with(id: 1)
        end
      end
    end
  end
end
