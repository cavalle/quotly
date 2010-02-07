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
      fill_in "Quote", :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in "By", :with => "Frank Lloyd Wright"
      click_button "Amend quote"
    end
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art’s sake is a philosophy of the well-fed.")
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
      fill_in "Quote", :with => "Art for art's sake is a philosophy of the well-fed."
      fill_in "By", :with => "Frank Lloyd Wright"
      fill_in "From", :with => "Unknown"
      click_button "Amend quote"
    end
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art’s sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
      page.should have_css(".source", :text => "Unknow")
    end
  end
  
  scenario "Amending styled quote" do
    create_quote :user => @user, :text => "_Wrong_ text", :author => "Wrong author"
    
    login_as @user
    visit "/"
    
    within(:css, ".quote") do
      click_link "Amend"
    end
    
    within(:css, "#edit_quote") do
      page.should have_css("textarea", :text => "_Wrong_ text")
      fill_in "Quote", :with => "*Wrong* text"
      click_button "Amend quote"
    end
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => /Wrong text/)
      page.should have_css(".text strong", :text => "Wrong")
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