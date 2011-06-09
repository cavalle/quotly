# encoding: UTF-8
require 'test_helper'

feature 'Amending quotes' do

  background do
    register_user :nickname => 'jdoe'
  end

  scenario 'Amending quote from the main page' do
    add_quote :nickname => 'jdoe', :text => 'Wrong text', :author => 'Wrong author'

    login_as 'jdoe'
    visit '/'

    within '.quote' do
      click_link 'Amend'
    end

    within '#edit_quote' do
      fill_in 'Quote', :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in 'By',    :with => 'Frank Lloyd Wright'
      click_button 'Amend quote'
    end

    page.must_have_css('.quote', :count => 1)
    within '.quote' do
      page.must_have_css('.text',   :text => 'Art for art’s sake is a philosophy of the well-fed.')
      page.must_have_css('.author', :text => 'Frank Lloyd Wright')
    end
  end

  scenario 'Amending quote from user page' do
    add_quote :nickname => 'jdoe', :text => 'Wrong text', :author => 'Wrong author'

    login_as 'jdoe'
    visit '/jdoe'

    within '.quote' do
      click_link 'Amend'
    end

    within '#edit_quote' do
      fill_in 'Quote', :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in 'By',    :with => 'Frank Lloyd Wright'
      fill_in 'From',  :with => 'Unknown'
      click_button 'Amend quote'
    end

    page.must_have_css('.quote', :count => 1)
    within '.quote' do
      page.must_have_css('.text',   :text => 'Art for art’s sake is a philosophy of the well-fed.')
      page.must_have_css('.author', :text => 'Frank Lloyd Wright')
      page.must_have_css('.source', :text => 'Unknow')
    end
  end

  scenario 'Amending styled quote' do
    add_quote :nickname => 'jdoe', :text => '_Wrong_ text', :author => 'Wrong author'

    login_as 'jdoe'
    visit '/'

    within '.quote' do
      click_link 'Amend'
    end

    within '#edit_quote' do
      page.must_have_css('textarea', :text => '_Wrong_ text')
      fill_in 'Quote', :with => '*Wrong* text'
      click_button 'Amend quote'
    end

    within '.quote' do
      page.must_have_css('.text', :text => /Wrong text/)
      page.must_have_css('.text strong', :text => 'Wrong')
    end
  end

  scenario "Can't amend others' quotes" do
    add_quote :nickname => 'proe', :text => 'Wrong text', :author => 'Wrong author'

    login_as 'jdoe'
    visit '/'
    page.wont_have_css('a', :text => 'Amend')

    visit '/jdoe'
    page.wont_have_css('a', :text => 'Amend')
  end

end
