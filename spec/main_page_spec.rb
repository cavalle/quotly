require File.dirname(__FILE__) + "/spec_helper"

feature "Main page" do
  scenario "should load" do
    visit "/"
    page.should have_content("Quotly")
    page.should_not have_css(".quote")
  end
  
  scenario "should show existing quotes" do
    create_quote :text => "The language of friendship is not words, but meanings", 
                 :author => "Henry David Thoreau"
    
    visit "/"
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "The language of friendship is not words, but meanings")
      page.should have_css(".author", :text => "Henry David Thoreau")
    end
  end
  
  scenario "should show 20 quotes" do
    25.times { create_quote }    
    visit "/"
    page.should have_css(".quote", :count => 20)
  end
  
  scenario "should show latest quotes first" do
    create_quote :text => "first"; sleep 0.1
    create_quote :text => "last"
    
    visit "/"
    
    page.should have_css(".quote:first", :text => "last")
    page.should have_css(".quote:last", :text => "first")
  end
  
end
