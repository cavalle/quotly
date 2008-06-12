ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'
require 'webrat'

def run_story(name, options = {})
  with_steps_for *options[:with_steps_for] do
    run File.join(File.dirname(__FILE__), name.to_s), :type => RailsStory
  end
end