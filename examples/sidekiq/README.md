# Working With Sidekiq

Use case 定義了唯一的 public method `call`，因此可以很好的契合 Sidekiq。

## 使用方法

只需要再另外定義 `perform`，並在裡面呼叫 `call`，便可以讓 use case 轉為 sidekiq 中的 job。 `worker.rb` 是一個簡單的範例 base class。

```ruby
class DoSomething < Boxenn::UseCase
  include Boxenn::Worker
  sidekiq_options queue: :default, retry: false

  def steps(params_a:, params_b:)
    do_something(params_a: params_a, params_b: params_b)
  end

  private

  def do_something(params_a:, params_b:)
    # do something
    Success()
  end
end
```

非同步呼叫\
`> DoSomething.perform_async(params_a: 123, params_b: 456)`\
同步呼叫\
`> DoSomething.new.call(params_a: 123, params_b: 456)`
