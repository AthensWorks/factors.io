class Number
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value,     type: String
  field :prime,     type: Boolean
  field :factors,   type: Hash
  field :factorization_duration, type: Float
  field :divisors,  type: Array
  field :status,    type: String

  validates_inclusion_of :status, in: ['complete', 'in-progress', 'queued', 'incomplete']
  validates_presence_of  :value, :status
  validates_format_of    :value, with: /^\d+$/
  validates_length_of    :value, maximum: 50

  def initialize(attrs = nil, options = nil)
    super
    self.status ||= "incomplete"
  end

  def self.ensure_integer_as_string(value)
    value.to_i.to_s if value.present?
  end

  def is_a_prime?
    divisors.length == 2
  end

  def complete?
    status == "complete"
  end

  def in_progress?
    status == "in-progress"
  end

  def queued?
    status == "queued"
  end

  def incomplete?
    status == "incomplete"
  end

end