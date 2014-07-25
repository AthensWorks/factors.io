require 'sidekiq'

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"]}
  end

  Sidekiq.configure_client do |config|
   config.redis = { url: ENV["REDISTOGO_URL"]}
  end
end

class FactorAndDivisorWorker
  include Sidekiq::Worker

  def perform(val)
    number = Number.find_or_initialize_by(value: val.to_s)

    if number.incomplete? || number.queued?
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