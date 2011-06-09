# encoding: UTF-8

require 'test_helper'

feature 'Adding quotes' do

  scenario "Anonymous users can't create quotes" do
    visit '/'
    page.wont_have_link('Add new quote')
  end

  scenario 'Logged in users can create quotes' do
    user = register_user(:nickname => 'jdoe')
    login_as 'jdoe'

    visit '/'

    click_link 'Add new quote'

    within '#new_quote' do
      fill_in 'Quote', :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in 'By', :with => 'Frank Lloyd Wright'
      click_button 'Add quote!'
    end

    page.current_path.must_equal '/jdoe'

    page.must_have_css('.quote', :count => 1)

    within '.quote' do
      page.must_have_css('.text', :text => 'Art for art’s sake is a philosophy of the well-fed.')
      page.must_have_css('.author', :text => 'Frank Lloyd Wright')
      page.wont_have_css('.source')
    end

    visit '/'

    page.must_have_css('.quote', :count => 1)
    within '.quote' do
      page.must_have_css('.text', :text => 'Art for art’s sake is a philosophy of the well-fed.')
      page.must_have_css('.author', :text => 'Frank Lloyd Wright')
    end
  end

  scenario 'Creating quotes with source' do
    user = register_user :nickname => 'jdoe'
    login_as 'jdoe'

    visit '/'

    click_link 'Add new quote'

    within '#new_quote' do
      fill_in 'Quote', :with => 'The night of the fight, you may feel a slight sting. That’s pride fucking with you. Fuck pride. Pride only hurts, it never helps.'
      fill_in 'By', :with => 'Marcellus Wallace'
      fill_in 'From', :with => 'Pulp Fiction'
      click_button 'Add quote!'
    end

    within '.quote' do
      page.must_have_css('.text', :text => 'The night of the fight, you may feel a slight sting. That’s pride fucking with you. Fuck pride. Pride only hurts, it never helps.')
      page.must_have_css('.author', :text => 'Marcellus Wallace')
      page.must_have_css('.source', :text => 'Pulp Fiction')
    end

  end

  scenario 'Creating quotes with style' do
    user = register_user :nickname => 'jdoe'
    login_as 'jdoe'

    visit '/'

    click_link 'Add new quote'

    within '#new_quote' do
      fill_in 'Quote', :with => 'The night of the fight,\n\nyou may _feel_ a slight sting'
      fill_in 'By', :with => 'Marcellus Wallace'
      click_button 'Add quote!'
    end

    within '.quote' do
      page.must_have_css('.text p', :text => 'The night of the fight')
      page.must_have_css('.text p', :text => /you may feel a slight sting/)
      page.must_have_css('.text em', :text => 'feel')
    end

  end

  describe 'only JS' do

    before { Capybara.current_driver = Capybara.javascript_driver }
    after  { Capybara.use_default_driver }

    scenario 'Author field is autocompleted' do
      user = register_user :nickname => 'jdoe'
      add_quote :author => 'Frank Sinatra'
      add_quote :author => 'Frank Lloyd Wright'
      add_quote :author => 'Alan Francis'
      login_as 'jdoe'

      visit '/'

      click_link 'Add new quote'

      within '#new_quote' do
        fill_in 'By', :with => 'Fran'
      end

      page.must_have_content('Frank Sinatra')
      page.must_have_content('Frank Lloyd Wright')
      page.must_have_content('Alan Francis')

      within '#new_quote' do
        fill_in 'By', :with => 'Frank'
      end

      page.must_have_no_content('Alan Francis')
      page.must_have_content('Frank Sinatra')
      page.must_have_content('Frank Lloyd Wright')
    end

    scenario 'Source field is autocompleted' do
      user = register_user :nickname => 'jdoe'
      add_quote :source => 'Sense and Sensibility'
      add_quote :source => 'It makes no sense'
      add_quote :source => 'My own sensibility'
      add_quote :source => nil # Make sure empty sources doesn't break the functionality
      login_as 'jdoe'

      visit '/'

      click_link 'Add new quote'

      within '#new_quote' do
        fill_in 'From', :with => 'sens'
      end

      page.must_have_content('Sense and Sensibility')
      page.must_have_content('It makes no sense')
      page.must_have_content('My own sensibility')

      within '#new_quote' do
        fill_in 'From', :with => 'sense'
      end

      page.must_have_no_content('My own sensibility')
      page.must_have_content('It makes no sense')
      page.must_have_content('Sense and Sensibility')
    end
  end
end
