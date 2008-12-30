load(File.expand_path(File.dirname(__FILE__) + '/lib/framework.rb'))

resource :quote do
  fields do |f|
    f.text     :text
    f.string   :author
    f.timestamps
  end  
end



