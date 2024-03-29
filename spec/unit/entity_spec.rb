require 'boxenn/entity'

RSpec.describe Boxenn::Entity do
  describe '#primary_keys_hash' do
    context 'when method is called without defining primary key' do
      class Test1 < Boxenn::Entity
      end
      subject { -> { entity.primary_keys_hash } }

      let(:entity) { Test1.new }

      it { is_expected.to raise_error(Boxenn::UndefinePrimaryKeys) }
    end

    context 'when method is called without assigning primary key' do
      class Test2 < Boxenn::Entity
        def self.primary_keys
          [:id1].freeze
        end
      end
      subject { -> { entity.primary_keys_hash } }

      let(:entity) { Test2.new }

      it { is_expected.to raise_error(Boxenn::UnassignPrimaryKeys) }
    end

    context 'when method is called with valid primary key' do
      context 'accepts single primary key' do
        class Test3 < Boxenn::Entity
          def self.primary_keys
            [:id1].freeze
          end

          attribute :id1, Types::Integer.default(1)
        end

        subject { entity.primary_keys_hash }

        let(:entity) { Test3.new }

        it { is_expected.to eq({ id1: 1 }) }
      end

      context 'accepts multiple primary key' do
        class Test4 < Boxenn::Entity
          def self.primary_keys
            %i[id1 id2].freeze
          end

          attribute :id1,                 Types::Integer.default(1)
          attribute :id2,                 Types::Integer.default(2)
        end

        subject { entity.primary_keys_hash }

        let(:entity) { Test4.new }

        it { is_expected.to eq({ id1: 1, id2: 2 }) }
      end
    end
  end
end
