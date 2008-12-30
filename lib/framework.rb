require 'rubygems'
require 'activerecord'
require 'sinatra'

database_config = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(database_config)

# auto-migrations
require File.expand_path(File.dirname(__FILE__) + '/vendor/auto_migrations/lib/auto_migrations')
ActiveRecord::Migration.send :include, AutoMigrations

class ActiveRecord::Base
  def self.fields(&block)
    ActiveRecord::Schema.create_table(table_name, &block)
  end
end

def resource(name, &block)
  resource = Object.const_set(name.to_s.capitalize, Class.new(ActiveRecord::Base))
  resource.class_eval(&block)
  
  get "/#{name.to_s.pluralize}" do
    instance_variable_set "@#{name.to_s.pluralize}", resource.all
    erb :"#{resource.table_name}/index.html"
  end
  
  get "/" do
    instance_variable_set "@#{name.to_s.pluralize}", resource.all
    erb :"#{resource.table_name}/index.html"
  end if resources.empty?
  
  resources << resource
  
end

@resources = []
def resources
  @resources
end