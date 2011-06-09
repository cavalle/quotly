require 'test_helper'

feature 'User page' do

  scenario "Should return 404 if user doesn't exist" do
    lambda { visit '/jdoe' }.must_raise ActiveRecord::RecordNotFound
  end

  scenario "Should return an empty page if the user doesn't have quotes" do
    register_user :nickname => 'jdoe'
    visit '/jdoe'
    page.must_have_content('No quotes saved by jdoe yet')
  end

  scenario "Should return only user's quotes" do
    register_user :nickname => 'jdoe'
    add_quote :text => 'The language of friendship is not words, but meanings',
              :author => 'Henry David Thoreau',
              :nickname => 'jdoe'
    add_quote

    visit '/jdoe'

    page.must_have_css('h2', :text => "jdoe's saved quotes")
    page.must_have_css('.quote', :count => 1)
    within('.quote') do
      page.must_have_css('.text',   :text => 'The language of friendship is not words, but meanings')
      page.must_have_css('.author', :text => 'Henry David Thoreau')
    end
  end

  scenario "Current users' is linked from main page" do
    register_user :nickname => 'jdoe'
    login_as 'jdoe'
    visit '/'
    click_link 'Your quotes'
    page.current_path.must_equal '/jdoe'
  end

  scenario 'Quotes link to the user who added them' do
    register_user :nickname => 'jdoe'
    add_quote :text => 'The language of friendship is not words, but meanings',
              :author => 'Henry David Thoreau',
              :nickname => 'jdoe'

    visit '/'

    within('.quote') do
      page.must_have_content('Added by jdoe')
      click_link 'jdoe'
    end

    page.current_path.must_equal '/jdoe'
  end

end
