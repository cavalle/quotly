require 'test_helper'

feature 'Main page' do
  scenario 'loads' do
    visit '/'

    page.must_have_content 'Quotly'
    page.wont_have_css '.quote'
  end

  scenario 'shows existing quotes' do
    add_quote :text   => 'The language of friendship is not words, but meanings',
              :author => 'Henry David Thoreau'

    visit '/'

    page.must_have_css '.quote', :count => 1
    within '.quote' do
      page.must_have_content 'The language of friendship is not words, but meanings'
      page.must_have_content 'Henry David Thoreau'
    end
  end

  scenario 'shows 20 quotes' do
    25.times { add_quote }
    visit '/'
    page.must_have_css '.quote', :count => 20
  end

  scenario 'shows latest quotes first' do
    add_quote :text => 'first'
    add_quote :text => 'last'

    visit '/'

    page.must_have_css '.quote:first', :text => 'last'
    page.must_have_css '.quote:last',  :text => 'first'
  end

end
