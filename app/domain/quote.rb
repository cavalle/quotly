class Quote
  include Entity

  def initialize(attributes)
    raise unless attributes[:text].present?
    apply_event :quote_added, attributes.merge(:uid => uid)
  end

  def amend(attributes)
    raise unless attributes[:text].present?
    apply_event :quote_amended, attributes.merge(:uid => uid)
  end
end
