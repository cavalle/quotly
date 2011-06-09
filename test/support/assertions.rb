module Assertions
  def assert_have_content(page, text)
    msg = message { "Page doesn't contain text '#{text}'" }
    assert page.has_content?(text), msg
  end

  def assert_have_no_content(page, text)
    msg = message { "Page contain text '#{text}' but it shouldn't" }
    assert page.has_no_content?(text), msg
  end

  def refute_have_content(page, text)
    msg = message { "Page contains text '#{text}' but it shouldn't" }
    refute page.has_content?(text), msg
  end

  def assert_have_css(page, selector, opts = {})
    msg = message { "CSS selector '#{selector}' #{opts.inspect} doesn't match current page" }
    assert page.has_css?(selector, opts), msg
  end

  def refute_have_css(page, selector, opts = {})
    msg = message { "CSS selector '#{selector}' #{opts.inspect} matches current page but it shouldn't" }
    refute page.has_css?(selector, opts), msg
  end

  def assert_have_link(page, text)
    assert_have_css(page, "a", :text => text)
  end

  def refute_have_link(page, text)
    refute_have_css(page, "a", :text => text)
  end

  Object.infect_an_assertion :assert_have_content,    :must_have_content,    true
  Object.infect_an_assertion :refute_have_content,    :wont_have_content,    true
  Object.infect_an_assertion :assert_have_no_content, :must_have_no_content, true
  Object.infect_an_assertion :assert_have_css,        :must_have_css,        true
  Object.infect_an_assertion :refute_have_css,        :wont_have_css,        true
  Object.infect_an_assertion :assert_have_link,       :must_have_link,       true
  Object.infect_an_assertion :refute_have_link,       :wont_have_link,       true
end

MiniTest::Spec.send :include, Assertions
