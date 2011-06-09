require 'test_helper'

feature 'Login & Register' do

  background do
    OmniAuth.config.add_mock 'twitter', {'uid' => '123545', 'user_info' => {'nickname' => 'jdoe'}}
  end

  scenario 'Not logged user' do
    visit '/'
    page.must_have_link('Login or Register')
    page.wont_have_link('Logout')
  end

  scenario 'Login with valid Twitter account and registration' do
    visit '/'

    click_link 'Login or Register'

    click_button 'Twitter'

    find_field('Confirm your nickname').value.must_equal 'jdoe'
    fill_in 'Confirm your nickname', :with => 'joe2'
    click_button 'Register!'

    page.current_path.must_equal '/'

    page.must_have_content('Hi, joe2!')
    page.must_have_link('Logout')
    page.wont_have_link('Login or Register')
  end

  scenario 'Login with valid Twitter account but no account and no registration' do
    visit '/'
    click_link 'Login or Register'

    click_button 'Twitter'

    visit '/'

    page.wont_have_content('Hi')
    page.wont_have_link('Logout')
    page.must_have_link('Login or Register')
  end

  scenario 'Logout' do
    visit '/'

    click_link 'Login or Register'
    click_button 'Twitter'

    visit "/users/new"
    click_button 'Register!'

    click_link 'Logout'

    page.wont_have_link('Logout')
    page.must_have_link('Login or Register')
  end

  scenario 'Login after registration' do
    visit '/'
    click_link 'Login or Register'
    click_button 'Twitter'
    click_button 'Register!'
    click_link 'Logout'
    click_link 'Login or Register'
    click_button 'Twitter'

    page.current_path.must_equal '/'
    page.must_have_link('Logout')
    page.wont_have_link('Login or Register')
  end

end
