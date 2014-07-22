class Integer
  def to_delimited(delimeter = ',')
    self.to_s.reverse.scan(/(\d{0,3})/).flatten.delete_if(&:empty?).join(delimeter).reverse
  end
end
