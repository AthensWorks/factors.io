class Number
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value,     type: String
  field :prime,     type: Boolean
  field :factors,   type: Hash
  field :divisors,  type: Array
  field :status,    type: String

  validates_inclusion_of :status, in: ['complete', 'in-progress', 'queued', 'incomplete']
  validates_presence_of  :value, :status
  validates_format_of    :value, with: /^\d+$/
  validates_length_of    :value, maximum: 18

  def self.ensure_integer_as_string(value)
    value.to_i.to_s if value.present?
  end
end