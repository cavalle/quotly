require File.dirname(__FILE__) + "/spec_helper"

feature "Quotes permalink" do
  
  scenario "Quotes shows its permalink" do
    create_quote :text => "last"; jump(1.second)
    create_quote :text => "first"
    
    visit "/"
    
    within(:css, ".quote:first") do
      click_link("Link")
    end
    
    page.should have_css(".quote", :text => "first")
    page.should have_no_css(".quote", :text => "last")
  end
  
end