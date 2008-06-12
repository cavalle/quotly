steps_for :users do
  Given "no $model_name with '$value' $field_name exists" do |model_name, value, field_name|
    model = model_name.capitalize.constantize
    model.count(:conditions => { field_name => value }).should == 0
    # is it clever to use shoulds in a given block?
  end

  When "visitor goes to the home page" do
    visits "/"
  end

  When "clicks on '$link'" do |link|
    clicks_link link
  end

  When "fills in $field with '$value'" do |field, value|
    fills_in field, :with => value
  end

  Then "the registration form should be shown" do
    response.should have_tag("div#new_user")
  end
  
  Then "an user with '$login' login and '$email' email should exist" do |login, email|
    User.exists?(:login => login, :email => email).should == true
    # wouldn't it be better: User.should_not.exist :login => login, :email => email
  end
end