require File.dirname(__FILE__) + "/spec_helper"

feature "Adding quotes" do
  
  scenario "Anonymous users can't create quotes" do
    visit "/"
    page.should_not have_css("a", :text => "Add new quote")
  end
  
  scenario "Logged in users can create quotes" do
    create_user :identity_url => "jdoe.com", :nickname => "jdoe"
    login_as "jdoe.com"
    
    visit "/"
    
    click_link "Add new quote"
    
    within(:css, "#new_quote") do
      fill_in "Text", :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in "Author", :with => "Frank Lloyd Wright"
      click_button "Add quote!"
    end
    
    page.path.should == "/jdoe"
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art's sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
    end
    
    visit "/"
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art's sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
    end
  end
  
end