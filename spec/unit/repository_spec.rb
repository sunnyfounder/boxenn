require 'boxenn/repository'

RSpec.describe Boxenn::Repository do

  describe '#find_by_identity' do
    context 'when method is called with keywords arguments' do
      context 'accepts matching primary keys' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:name] }

        subject { -> { repository.find_by_identity(name: 1) } }
        it { is_expected.not_to raise_error }
      end

      context 'rejects unnecessary primary keys' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:id, :name] }

        subject { -> { repository.find_by_identity(name: 1) } }
        it { is_expected.to raise_error(Boxenn::InvalidPrimaryKey) }
      end
    end

    context 'when matching primary key is set' do

      context 'accepts single primary key' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:name] }

        specify do
          repository.find_by_identity(name: 'Name')
          expect(source_wrapper).to have_received(:find_by).with(name: 'Name')
        end
      end

      context 'accepts multiple primary key' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:id, :name] }

        specify do
          repository.find_by_identity(id: 1, name: 'Name')
          expect(source_wrapper).to have_received(:find_by).with(id: 1, name: 'Name')
        end
      end

      context 'accepts not defined and defaults to :id' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:id] }

        specify do
          repository.find_by_identity(id: 1)
          expect(source_wrapper).to have_received(:find_by).with(id: 1)
        end
      end

      context 'delegates factory to build' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:name] }
        specify do
          repository.find_by_identity(name: 'Name')
          expect(factory).to have_received(:build).with('record')
        end
      end

      context 'returns factory result' do
        let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, factory: factory) }
        let(:factory) { spy('factory', build: 'entity', primary_keys: primary_keys) }
        let(:source_wrapper) { spy('source wrapper', find_by: 'record') }
        let(:primary_keys) { [:name] }

        subject { repository.find_by_identity(name: 'Name') }
        it { is_expected.to eq('entity') }
      end
    end
  end

  describe '#find_by_query' do
    let(:repository) { Boxenn::Repository.new(factory: factory) }
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
    let(:repository) { Boxenn::Repository.new(source_wrapper: source_wrapper, record_mapper: record_mapper) }
    let(:record_mapper) do
      record_mapper = spy('record_mapper')
      allow(record_mapper).to receive(:build).with({ id: 1 }).and_return({ id: 1 })
      allow(record_mapper).to receive(:build).with({ id: 1, hash: 'attributes' }).and_return({ id: 1, schema: 'attributes' })
      record_mapper
    end
    let(:source_wrapper) { spy('source wrapper', save: 'result') }
    let(:entity) { spy('entity', primary_keys_hash: { id: 1 }, to_h: { id: 1, hash: 'attributes' }) }

    context 'when entity is provided' do
      before { repository.save(entity) }

      context 'maps the entity into an attribute hash' do
        it { expect(record_mapper).to have_received(:build).twice }
      end

      context 'requires the source mapper to store record with updated attributes' do
        it { expect(source_wrapper).to have_received(:save).with({ id: 1 }, { id: 1, schema: 'attributes' }) }
      end

      context 'returns the result' do
        subject { repository.save(entity) }
        it { is_expected.to eq('result') }
      end
    end
  end
end
