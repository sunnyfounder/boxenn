class Repository
  option :source, default: proc { ::Airrecord.table(ENV['AIRTABLE_API_KEY'], ENV['AIRTABLE_BASE_ID'], '進度管理') }
  option :factory_class, default: proc { Entities::Factory }
  option :adapter_class, default: proc { Entities::Adapter }

  def find_by_identity(name:)
    record = source.find_by(name: name)
    build(record)
  end

  def find_by_query(query)
    records = query.collect
    build_collection(records)
  end

  # def create(data)
  #   factory_class.create(data)
  # end

  def save(entity)
    if entity.id.nil?
      adapter_class.create(entity: entity, external_object: external_object)
    else
      adapter_class.save(entity: entity, external_object: external_object)
    end
  end

  private

  def build_collection()

  end

  def build()

  end

end

class Query
  option :source, default: proc { ::Airrecord.table(ENV['AIRTABLE_API_KEY'], ENV['AIRTABLE_BASE_ID'], '進度管理') }

  def collect

  end
end
