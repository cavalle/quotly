$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'activerecord'
require 'sinatra'

database_config = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(database_config)

# auto-migrations
$:.unshift(File.dirname(__FILE__) + '/vendor/auto_migrations/lib')
require 'vendor/auto_migrations/init'

class ActiveRecord::Base
  def self.fields(&block)
    ActiveRecord::Schema.create_table(table_name, &block)
  end
end

module Mojito
  
  module DSL
    
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
      end if Mojito.resources.empty?
  
      Mojito.resources << resource
      
    end
  
  end

  def self.resources
    @@resources ||= []
  end

end

Sinatra.application.clearables << Mojito.resources

include Mojito::DSL