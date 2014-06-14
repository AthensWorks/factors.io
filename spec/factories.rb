FactoryGirl.define do
  factory :number do
    value    40
    factors  [1, 2, 4, 5, 8, 10, 20, 40]
    status   "complete"
  end
end
