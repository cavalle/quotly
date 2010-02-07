require File.dirname(__FILE__) + "/spec_helper"

feature "Login & Register" do
  
  scenario "Login with invalid OpenID"
  scenario "Login with valid OpenID but not succeded"
  
  scenario "Not logged user" do
    visit "/"
    page.should have_css("a", :text => "Login or Register")
    page.should_not have_css("a", :text => "Logout")
  end
  
  scenario "Login with valid OpenID and registration" do
    visit "/"
    click_link "Login or Register"

    fill_in "OpenID", :with => "http://jdoe.openid.com"
    click_button "Go!"

    fill_in "Choose a nickname", :with => "jdoe"
    click_button "Register!"
    
    page.path.should == "/"
    
    page.should have_css("a", :text => "Logout")
    page.should_not have_css("a", :text => "Login or Register")
  end
  
  scenario "Taken nickname"
  
  scenario "Empty nickname"
  
  scenario "Cannot register twice or already registered"
  
  scenario "Login with valid OpenID but no account and no registration" do
    visit "/"
    click_link "Login or Register"

    fill_in "OpenID", :with => "http://jdoe.openid.com"
    click_button "Go!"
    
    visit "/"

    page.should have_css("a", :text => "Login or Register")
    page.should_not have_css("a", :text => "Logout")
  end

  scenario "Login with valid OpenID and an existing account" do
    create_user :nickname => "jdoe", :external_id => "http://jdoe.openid.com"
    
    visit "/"
    click_link "Login or Register"
    
    fill_in "OpenID", :with => "http://jdoe.openid.com"
    click_button "Go!"
    
    page.path.should == "/"
    
    page.should have_css("a", :text => "Logout")
    page.should_not have_css("a", :text => "Login or Register")
  end
  
  scenario "Logout" do
    create_user :nickname => "jdoe", :external_id => "http://jdoe.openid.com"
    
    visit "/"
    click_link "Login or Register"
    
    fill_in "OpenID", :with => "http://jdoe.openid.com"
    click_button "Go!"
    
    click_link "Logout"
    
    page.should_not have_css("a", :text => "Logout")
    page.should have_css("a", :text => "Login or Register")
  end
  
  scenario "Login after registration" do
    visit "/"
    click_link "Login or Register"

    fill_in "OpenID", :with => "http://jdoe.openid.com"
    click_button "Go!"

    fill_in "Choose a nickname", :with => "jdoe"
    click_button "Register!"

    click_link "Logout"
    click_link "Login or Register"

    fill_in "OpenID", :with => "http://jdoe.openid.com"
    click_button "Go!"

    page.path.should == "/"

    page.should have_css("a", :text => "Logout")
    page.should_not have_css("a", :text => "Login or Register")
  end
  
end