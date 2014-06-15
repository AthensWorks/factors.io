class Number
  include Mongoid::Document

  field :value,   type: String
  field :factors, type: Array
  field :status,  type: String

  validates_inclusion_of :status, in: ['complete', 'in_progress', 'queued']
  validates_presence_of  :value
  validates_format_of    :value, with: /^\d+$/


  def self.ensure_integer_as_string(value)
    value.to_i.to_s if value.present?
  end

  def has_factors?
    factors?
  end
end