# A mapper extension

It can help you build mapper fast and simple.

## Usage

Define `map` with hash, hash key represent the name of the entity attributes and hash value represent the schema of the source.

When encounter nested hash, set value to an array, first value represent the schema of the source, second value is another hash.

When mapping is not enough, define a method `custom_mapping` with two params `input` and `result`, input is the raw entity hash, and result is hash transform by `map`, Just return the final hash result.

```ruby
class SimpleMap < MapperExtension
  def map
    {
      a: :a,
      b: :b_,
      c: [
        :c_,
        {
          ca: :ca,
        }
      ],
    }
  end

  def custome_mapping(input:, result:)
    result[:total_price] = input[:amount] * input[:capacity]
    result
  end
end
```

Above example will turn

```ruby
{
  a: 123,
  b: 456,
  c: {
    ca: 789,
  }
  amount: 10,
  capacity: 5,
}
```

into

```ruby
{
  a: 123,
  b_: 456,
  c_: {
    ca: 789,
  },
  total_price: 50,
}
```
