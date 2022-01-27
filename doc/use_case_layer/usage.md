# Use Case Layer

### Basic Usage

 `Boxenn::UseCase` was built with [dry-monads](https://dry-rb.org/gems/dry-monads/1.3/) and [dry-initializer](https://dry-rb.org/gems/dry-initializer/3.0/), You can simply define your service object based on it.

```ruby
class SendEmailWhenOrderCreated < Boxenn::UseCase
  option :order_repository, default: -> { OrderRepository.new }
  option :mailer, default: -> { Mailer.new }

  def steps(order_id:)
    order = yield retrieve_order(order_id)
    message = build_message(order)
    send_email(message)
  end

  private

  def retrieve_order(order_id)
    order = order_repository.find_by(id: order_id)
    return Failure("Can't find any order with id #{order_id}") if order.nil?

    Success(order)
  end

  def build_message(order)
    "Your order #{order.serial_number} has been created!"
  end

  def send_email(message)
    result = mailer.deliver(message)
    if result.success?
      Success()
    else
      Failure(result.errors)
    end
  end
end

use_case = SendEmailWhenOrderCreated.new
result = use_case.call(order_id)
result.success? # true

use_case2 = SendEmailWhenOrderCreated.new(mailer: AnotherMailer.new)
result = use_case2.call(order_id)
result.success? # true
```
- The return value of `steps` must be an object of [dry-monads](https://dry-rb.org/gems/dry-monads/1.3/result/) `Result`.
- If you want to declare `Failure`, please `yield` the method you call in steps except the last one.

### Advanced Usage

* [Working With Sidekiq](/examples/sidekiq/README.md)
