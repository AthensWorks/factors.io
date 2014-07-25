FactoryGirl.define do
  factory :number do
    value    '40'
    factors  ({'2' => '3', '5' => '1'})
    divisors  ['1', '2', '4', '5', '8', '10', '20', '40']
    prime    false
    status   "complete"
    factorization_duration 5.234

    factory :number_with_random_value do
      sequence(:value)
      factors  ({})
      divisors  []
      prime    nil
      status   "incomplete"
    end
  end
end
