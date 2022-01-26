RSpec.shared_examples 'a repository' do
  describe '.save' do
    it 'create record by entity' do
      repo.save(entity)
      actual_entity = repo.find_by_identity(identity)
      expect(actual_entity.to_h).to include(entity.to_h)
    end
  end

  describe '.destroy' do
    it 'destroy record by identity' do
      repo.save(entity)
      repo.destroy(entity)
      actual_entity = repo.find_by_identity(identity)
      expect(actual_entity).to be_nil
    end
  end
end

RSpec.shared_examples 'a readonly repository' do
  describe '.find_by_identity' do
    it 'find entity by identity' do
      actual_entity = repo.find_by_identity(identity)
      expect(actual_entity.to_h).to include(entity.to_h)
    end
  end
end
