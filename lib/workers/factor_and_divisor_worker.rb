require 'sidekiq'

# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  # config.redis = { :namespace => 'sidekiq', :size => Integer(ENV["SIDEKIQ_WORKER_SIZE"] || 3) }
end

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |config|
  # config.redis = { :namespace => 'sidekiq' }
end

class FactorAndDivisorWorker
  include Sidekiq::Worker

  def perform(val)
    number = Number.find_or_initialize_by(value: val.to_s)

    if number.incomplete?
      number.update_attributes(status: "in-progress")

      with_factorization_time(number) do
        number.factors = PARI::GP.factors(number.value)
      end

      number.divisors = PARI::GP.divisors(number.value)

      number.prime  = number.is_a_prime?
      number.status = "complete"
      number.save
    end
  end

  private

  def with_factorization_time(number)
    start_time = Time.now

    yield

    end_time = Time.now
    number.factorization_duration = end_time - start_time
  end
end