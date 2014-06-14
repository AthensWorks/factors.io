class Number
  include Mongoid::Document

  field :value,   type: Integer
  field :factors, type: Array
  field :status,  type: String

  validates_inclusion_of :status, in: ['complete', 'in_progress', 'queued']

  def has_factors?
    factors?
  end
end