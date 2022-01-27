# A domain with repository example code

## Usage

```ruby
repository = Receipt::Repositories::Receipt.new
repository.find_by_identity(custom_serial_number: 'ABC123456') # receipt entity
```

## Features

### Easily testing in repository

Shared example following below steps

1. create entity and save to source(e.g. database) by repository.
2. retrieve entity by giving identity
3. match wheather they are same
and it can be used in every domains.

### Easily testing in use case

Simple replace repository using dependency injection, let the test run without knowing data access detail.

### Domain Driven

The only way to modify data is through repository, so you can easily discover all the side effect in code.
