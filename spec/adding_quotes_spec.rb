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
      page.should have_css(".text", :text => "Art for art’s sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
      page.should_not have_css(".source")
    end
    
    visit "/"
    
    page.should have_css(".quote", :count => 1)
    within(:css, ".quote") do
      page.should have_css(".text", :text => "Art for art’s sake is a philosophy of the well-fed.")
      page.should have_css(".author", :text => "Frank Lloyd Wright")
    end
  end
  
  scenario "Creating quotes with source" do
    user = create_user :nickname => "jdoe"
    login_as user
    
    visit "/"
    
    click_link "Add new quote"
    
    within(:css, "#new_quote") do
      fill_in "Quote", :with => "The night of the fight, you may feel a slight sting. That’s pride fucking with you. Fuck pride. Pride only hurts, it never helps."
      fill_in "By", :with => "Marcellus Wallace"
      fill_in "From", :with => "Pulp Fiction"
      click_button "Add quote!"
    end
    
    within(:css, ".quote") do
      page.should have_css(".text", :text => "The night of the fight, you may feel a slight sting. That’s pride fucking with you. Fuck pride. Pride only hurts, it never helps.")
      page.should have_css(".author", :text => "Marcellus Wallace")
      page.should have_css(".source", :text => "Pulp Fiction")
    end
    
  end
  
  scenario "Creating quotes with style" do
    user = create_user :nickname => "jdoe"
    login_as user

    visit "/"

    click_link "Add new quote"

    within(:css, "#new_quote") do
      fill_in "Quote", :with => "The night of the fight,\n\nyou may _feel_ a slight sting"
      fill_in "By", :with => "Marcellus Wallace"
      click_button "Add quote!"
    end 
    
    within(:css, ".quote") do
      page.should have_css(".text p", :text => "The night of the fight")
      page.should have_css(".text p", :text => /you may feel a slight sting/)
      page.should have_css(".text em", :text => "feel")
    end

  end
  
  context "only JS" do
    
    before { Capybara.current_driver = :culerity }
    after  { Capybara.use_default_driver }
  
    scenario "Author field is autocompleted" do
      user = create_user :nickname => "jdoe"
      create_quote :author => "Frank Sinatra"
      create_quote :author => "Frank Lloyd Wright"
      create_quote :author => "Alan Francis"
      login_as user

      visit "/"

      click_link "Add new quote"
      
      within(:css, "#new_quote") do
        fill_in "By", :with => "Fran"
      end
            
      page.should have_content("Frank Sinatra")
      page.should have_content("Frank Lloyd Wright")
      page.should have_content("Alan Francis")
      
      within(:css, "#new_quote") do
        fill_in "By", :with => "Frank"
      end
      
      page.should have_no_content("Alan Francis")
      page.should have_content("Frank Sinatra")
      page.should have_content("Frank Lloyd Wright")
    end
    
    scenario "Source field is autocompleted" do
      user = create_user :nickname => "jdoe"
      create_quote :source => "Sense and Sensibility"
      create_quote :source => "It makes no sense"
      create_quote :source => "My own sensibility"
      login_as user
    
      visit "/"
    
      click_link "Add new quote"
      
      within(:css, "#new_quote") do
        fill_in "From", :with => "sens"
      end
            
      page.should have_content("Sense and Sensibility")
      page.should have_content("It makes no sense")
      page.should have_content("My own sensibility")
      
      within(:css, "#new_quote") do
        fill_in "From", :with => "sense"
      end
      
      page.should have_no_content("My own sensibility")
      page.should have_content("It makes no sense")
      page.should have_content("Sense and Sensibility")
    end
  
  end
end