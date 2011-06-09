class User
  include Entity

  def initialize(attributes)
    raise unless attributes[:external_uid].present?
    apply_event :user_registered, attributes.merge(:uid => uid)
  end
end
