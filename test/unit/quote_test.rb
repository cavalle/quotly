require File.dirname(__FILE__) + '/../test_helper'

class QuoteTest < Test::Unit::TestCase
  fixtures :quotes, :users

  def test_quote_with_no_user_should_be_invalid
    quote = Quote.new
    assert !quote.valid?
    assert quote.errors.invalid?(:user)
  end
  
  def test_valid_quote
    quote = users(:quentin).quotes.build
    assert quote.valid?
  end
end
