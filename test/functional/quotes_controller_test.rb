require File.dirname(__FILE__) + '/../test_helper'
require 'quotes_controller'

# Re-raise errors caught by the controller.
class QuotesController; def rescue_action(e) raise e end; end

class QuotesControllerTest < Test::Unit::TestCase
  def setup
    @controller = QuotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
