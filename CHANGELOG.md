# Changelog

## 4.0.0

支援 Ruby 3.2 以上（含 Ruby 4）。**不相容變更**：

- `UseCase#call` 把位置參數與關鍵字參數原樣轉給 `steps`。Ruby 2 會把最後一個 Symbol-key Hash 自動轉成關鍵字參數（反之亦然），Ruby 3 起不再轉換：
  `steps(foo:)` 收到 Hash 時要寫 `call(**hash)`，不能 `call(hash)`。（反方向 `steps(params)` 用 `call(foo: 1)` 呼叫，Ruby 3 仍會自動包成 Hash，不受影響。）
- 修正 `Repository#find_by_identity` 在 Ruby 3 下用位置參數呼叫 `retrieve_record(**attributes)` 而失敗；同時接受關鍵字（`find_by_identity(id: 1)`）與 identity hash（`find_by_identity(entity.primary_keys_hash)`）。
- 最低 Ruby 版本改為 3.2。
- 放寬相依：`wisper` 2.x–3.x、`dry-struct` 1.x。
- 移除 `require 'ostruct'`（Ruby 3.5 起不是預設 gem，也沒有用到）。

新增 `Boxenn::Job`（選用，`require 'boxenn/job'`）：讓 UseCase 透過 ActiveJob 在背景執行，取代各專案自己包的 Sidekiq worker。

```ruby
class SyncProject < Boxenn::UseCase
  include Boxenn::Job
  job_options queue: :general, retry: 3   # retry: true（預設 25 次）／false／次數；dead: false 用完直接丟棄

  def steps(project_id:) ... end
end

SyncProject.perform_later(project_id: 1)
SyncProject.set(wait: 5.minutes).perform_later(project_id: 1)
```

- include 時在類別底下建 `SyncProject::Job`（繼承 `Boxenn::Job.base_class`，預設 `ActiveJob::Base`，Rails 專案可設成 `'ApplicationJob'`）。排程設定（cron）寫的是這個類別。
- 執行時 `SyncProject.new.call(...)`，關鍵字參數維持關鍵字參數；回傳 `Failure` 會 raise `Boxenn::Job::Failed`，走重試。
- 子類別各自有一個 `::Job`（繼承父類別的佇列與重試設定），執行時跑子類別。
- 執行中的 use case 可以用 `job_id` 拿到 ActiveJob 的 job id。
- 用哪個佇列後端（Solid Queue、Sidekiq…）由專案的 `config.active_job.queue_adapter` 決定。
