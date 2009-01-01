require 'lib/framework'

resource :quote do
  fields do |f|
    f.text     :text
    f.string   :author
    f.timestamps
  end  
end



