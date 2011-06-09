require 'test_helper'

feature 'Quotes permalink' do

  scenario 'Quotes shows its permalink' do
    add_quote :text => 'last'; jump(1.second)
    add_quote :text => 'first'

    visit '/'

    within '.quote:first' do
      click_link 'Link'
    end

    page.must_have_css('.quote', :text => 'first')
    page.wont_have_css('.quote', :text => 'last')
  end

end
