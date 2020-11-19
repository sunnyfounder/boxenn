require 'homebrew/repository'

RSpec.describe Homebrew::Repository do

  describe '#find_by_identity' do
    let(:repository) { Homebrew::Repository.new(source: source, primary_key: primary_key, factory: factory) }
    let(:factory) { spy('factory', build: 'entity') }
    let(:source) { spy('source wrapper', find_by: 'record') }
    let(:primary_key) { [:name] }

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
        let(:repository) { Homebrew::Repository.new(source: source, factory: factory) }

        specify do
          repository.find_by_identity(id: 1)
          expect(source).to have_received(:find_by).with(id: 1)
        end
      end

      context 'delegates factory to build' do
        specify do
          repository.find_by_identity(name: 'Name')
          expect(factory).to have_received(:build).with('record')
        end
      end

      context 'returns factory result' do
        subject { repository.find_by_identity(name: 'Name') }
        it { is_expected.to eq('entity') }
      end
    end
  end

  describe '#find_by_query' do
    let(:repository) { Homebrew::Repository.new(factory: factory) }
    let(:factory) { spy('factory', build: 'entity') }
    let(:query) { spy('query', collect: ['record', 'record']) }

    context 'when an Enumerable is provided' do
      context 'collects records from relation' do
        specify do
          repository.find_by_query(query)
          expect(query).to have_received(:collect)
        end
      end

      context 'returns an array of entities' do
        subject { repository.find_by_query(query) }
        it { is_expected.to contain_exactly('entity', 'entity') }
      end
    end
  end

  describe '#save' do
    let(:repository) { Homebrew::Repository.new(source: source, record_mapper: record_mapper) }
    let(:record_mapper) { spy('record_mapper', build: { hash: 'attributes' }) }
    let(:source) { spy('source wrapper', save: 'result') }
    let(:entity) { spy('entity', keys: [:id], id: 'id') }

    context 'when entity is provided' do
      before { repository.save(entity) }

      context 'maps the entity into an attribute hash' do
        it { expect(record_mapper).to have_received(:build).with(entity) }
      end

      context 'requires the source mapper to store record with updated attributes' do
        it { expect(source).to have_received(:save).with({ hash: 'attributes' }) }
      end

      context 'returns the result' do
        subject { repository.save(entity) }
        it { is_expected.to eq('result') }
      end
    end
  end
end
