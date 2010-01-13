require File.dirname(__FILE__) + "/spec_helper"

feature "Amending quotes" do
  
  background do
    @user = create_user(:nickname => "jdoe")
  end
  
  scenario "Amending quote from the main page" do
    create_quote :user => @user, :text => "Wrong text", :author => "Wrong author"
    
    login_as @user
    visit "/"
    
    within(:css, ".quote") do
      click_link "Amend"
    end
    
    within(:css, "#edit_quote") do
      fill_in "Text", :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in "Author", :with => "Frank Lloyd Wright"
      click_button "Amend quote"
    end
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art's sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
    end
  end
  
  scenario "Amending quote from user page" do
    create_quote :user => @user, :text => "Wrong text", :author => "Wrong author"
    
    login_as @user
    visit "/jdoe"
    
    within(:css, ".quote") do
      click_link "Amend"
    end
    
    within(:css, "#edit_quote") do
      fill_in "Text", :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in "Author", :with => "Frank Lloyd Wright"
      click_button "Amend quote"
    end
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art's sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
    end
  end
  
  scenario "Can't amend others' quotes" do
    create_quote :user => create_user, :text => "Wrong text", :author => "Wrong author"
    login_as @user
    visit "/"
    page.should_not have_css("a", :text => "Amend")
    
    visit "/jdoe"
    page.should_not have_css("a", :text => "Amend")
  end
  
end