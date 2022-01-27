# Data Access Layer

## Basic Usage
To execute queries and commands against a database with `Boxenn::Repository`, you'll need to first create following classes.

### Entity
A model domain object in an application. It probably represent a real world object or concept. See "Domain Driven Design" by Eric Evans for more details.  

You need to define `primary_keys` to let other class identify entity.

```ruby
class Customer < Boxenn::Entity
  def self.primary_keys
    %i[id_number]
  end

  GENDER = { male: 'male', female: 'female', other: 'other' }.freeze

  attribute :id_number,   Types::String
  attribute :gender,      Types::Symbol.enum(GENDER)
  attribute :name,        Types::String
end
```

### Factory
Build entity from all kind of sources, such as database、airtable、file etc.

The only method need to be defined is `build`.

```ruby
class CustomerFactory < Boxenn::Repositories::Factory
  option :entity, default: -> { Customer }

  def build(source_object)
    entity.new(
      id_number: source_object.id_number,
      gender: source_object.gender,
      name: source_object.nick_name,
    )
  end
end
```

### Record Mapper
Mapping Entity's attributes to source attributes.

The only method need to be defined `build`.The parameters will be plain ruby hash.

```ruby
def CustomerMapper < Boxenn::Repositories::RecordMapper
  def build(hash)
    {
      id_number: hash[:id_number],
      gender: hash[:gender],
      nick_name: hash[:name],
    }
  end
end
```

### Source Wrapper
Wrapping up source with proper interface to let repository works.

You need to define 3 methods(`save`, `destroy`, `find_by`).The parameters will be plain ruby hash.
```ruby
class CustomerSourceWrapper < Boxenn::Repositories::SourceWrapper
  option :source, default: -> { CustomerModel }

  def save(primary_keys, attributes)
    record = source.find_or_initialize_by(primary_keys)
    record.assign_attributes(attributes)
    record.save!
  end

  def destroy(primary_keys)
    record = find_by(primary_keys)
    record.destroy!
  end

  def find_by(hash)
    records = source.where(primary_keys)
    raise(StandardError, "#{source} 違反唯一 primary keys, primary keys 為 #{primary_keys}") if records.size > 1

    records.first
  end
end
```

### Query (optional)
Define complicated queries.

The only method need to be defined `collect`, and return array of source objects.`Factory`
 will call `collect` and transform source object to entities.

```ruby
class CustomerQuery < Boxenn::Repositories::Query
  param :relation, default: -> { CustomerModel }

  def find_by_gender(gender)
    @relation = relation.where(gender: gender)
    self
  end

  def collect
    relation
  end
end
```

### Repository
When a class inherits from `Boxenn::Repository`, it will receive the following interface:
- `#find_by_identity(hash)` - Find the entity by primary keys

- `#find_by_query(query)` - Fetch all the entities from the relation

- `#save([entities])` - Create or Update entities by primary keys

- `#destroy([entities])` - Delete entities by primary keys


```ruby
class CustomerRepository < Boxenn::Repository
      option :source_wrapper, default: -> { CustomerSourceWrapper.new }

      option :record_mapper, default: -> { CustomerRecordMapper.new }

      option :factory, default: -> { CustomerFactory.new }
end
```
