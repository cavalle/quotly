require File.expand_path(File.dirname(__FILE__) + '/../quotes')
require 'webrat'
require 'webrat/mechanize'
require 'spec'
require "webrat/core/matchers"

World do
  include Webrat::Methods
  include Spec::Matchers
  include Webrat::Matchers
  include Webrat::HaveTagMatcher
  
  def response
    webrat_session.response
  end
end

Before do
  connection = ActiveRecord::Base.connection
  connection.tables.each do |table|
    connection.execute "DELETE FROM #{table}" 
  end
end

Given /^the following quotes has been created:$/ do |table|
  Quote.create!(table.hashes)
end

When /^I visit the home page of q\.uot\.es$/ do
  visit "http://localhost:4567"
end

Then /^I should see the following (.+):$/ do |resource, table|
  table.hashes.each do |hash|
    response.should have_xpath("//*[@class='#{resource.singularize}']#{hash.keys.map{|key|"[*[@class='#{key}'][text()='#{hash[key]}']]"}.join}")
  end
end
