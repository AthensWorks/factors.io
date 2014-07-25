require 'sidekiq'

# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'sidekiq', :size => Integer(ENV["SIDEKIQ_WORKER_SIZE"] || 3) }
end

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'sidekiq' }
end

class FactorAndDivisorWorker
  include Sidekiq::Worker

  def perform(val)
    puts "STARTING WORKER"
    puts val
    number = Number.find_by(value: val.to_s)

    number.status = "in-progress"
    number.save

    puts number.inspect

    with_factorization_time(number) do
      number.factors = PARI::GP.factors(number.value)
    end

    puts number.inspect

    number.divisors = PARI::GP.divisors(number.value)

    puts number.inspect

    number.prime  = number.is_a_prime?
    number.status = "complete"
    number.save
  end

  private

  def with_factorization_time(number)
    start_time = Time.now

    yield

    end_time = Time.now
    number.factorization_duration = end_time - start_time
  end
end