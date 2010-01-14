require File.dirname(__FILE__) + "/spec_helper"

feature "Adding quotes" do
  
  scenario "Anonymous users can't create quotes" do
    visit "/"
    page.should_not have_css("a", :text => "Add new quote")
  end
  
  scenario "Logged in users can create quotes" do
    user = create_user :nickname => "jdoe"
    login_as user
    
    visit "/"
    
    click_link "Add new quote"
    
    within(:css, "#new_quote") do
      fill_in "Quote", :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in "By", :with => "Frank Lloyd Wright"
      click_button "Add quote!"
    end
    
    page.path.should == "/jdoe"
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art's sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
      page.should_not have_css(".source")
    end
    
    visit "/"
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art's sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
    end
  end
  
  scenario "Creating quotes with source" do
    user = create_user :nickname => "jdoe"
    login_as user
    
    visit "/"
    
    click_link "Add new quote"
    
    within(:css, "#new_quote") do
      fill_in "Quote", :with => "The night of the fight, you may feel a slight sting. That's pride fucking with you. Fuck pride. Pride only hurts, it never helps."
      fill_in "By", :with => "Marcellus Wallace"
      fill_in "From", :with => "Pulp Fiction"
      click_button "Add quote!"
    end
    
    within(:css, ".quote") do
      page.should have_css(".text", :text => "The night of the fight, you may feel a slight sting. That's pride fucking with you. Fuck pride. Pride only hurts, it never helps.")
      page.should have_css(".author", :text => "Marcellus Wallace")
      page.should have_css(".source", :text => "Pulp Fiction")
    end
    
  end
  
end