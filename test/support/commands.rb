module CommandHelpers
  def add_quote(attrs = {})
    attrs[:text] ||= "Lorem ipsum dolor"
    Quote.new(attrs)
  end

  def register_user(attrs = {})
    attrs[:external_uid] = "twitter:#{attrs[:nickname]}"
    User.new(attrs)
  end
end

MiniTest::Unit::TestCase.send :include, CommandHelpers
