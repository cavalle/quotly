require File.dirname(__FILE__) + "/spec_helper"

feature "User page" do

  scenario "Should return 404 if user doesn't exist" do
    visit "/jdoe"
    page.should have_content("Page not found")
  end
  
  scenario "Should return an empty page if the user doesn't have quotes" do
    create_user :nickname => "jdoe"
    visit "/jdoe"
    page.should have_content("No quotes saved by jdoe yet")
  end
  
  scenario "Should return only user's quotes" do
    user = create_user :nickname => "jdoe"
    create_quote :text => "The language of friendship is not words, but meanings", 
                 :author => "Henry David Thoreau", 
                 :user => user
    create_quote
    
    visit "/jdoe"
    
    page.should have_css("h3", :text => "jdoe's saved quotes")
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "The language of friendship is not words, but meanings")
      page.should have_css(".author", :text => "Henry David Thoreau")
    end
  end
  
  scenario "Current users' is linked from main page" do
    user = create_user :nickname => "jdoe", :identity_url => "jdoe.com"
    login_as "jdoe.com"
    visit "/"
    click_link "Your quotes"
    page.path.should == "/jdoe"
  end
  
end