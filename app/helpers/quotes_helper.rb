module QuotesHelper
  def get_size_class(text)
		case text.length
		  when 0..49    then  "size_xxl"
  		when 50..99   then  "size_xl"
  		when 100..124 then  "size_l"
  		when 125..149 then  "size_m"
  		when 150..174 then  "size_s"
  		when 175..199 then  "size_xs"
  		else                "size_xxs"
		end		
	end
	
	def get_source_link(text)
	  if text =~ /"([^"]*)"\s*:\s*(http:\/\/\S*)/
	    "<a href='#{$2.strip}'>#{$1.strip}</a>"
	  elsif text =~ /\s*(http:\/\/\S*)/
	    "<a href='#{$1.strip}'>source</a>"	    
	  else
	    text
	  end 
	end
	
	def html_format_quote(text)
	  "<p class='first_p'>&ldquo;" + text.strip.gsub(/\s*\n\s*\n\s*/,'</p><p>') + "&rdquo;</p>"
  end
end
