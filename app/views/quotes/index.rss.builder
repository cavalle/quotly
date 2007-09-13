xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.rss "version" => "2.0" do
  xml.channel do
    xml.title @title
    xml.link quotes_url
    xml.language "en-us"
    xml.ttl "60"

    @quotes.each do |quote|
      xml.item do
        xml.title "Quote posted by %s @ %s" % [quote.user.login, quote.created_at.strftime("%x")]
        xml.description "\"%s\" by %s%s" % [quote.text, quote.author, quote.source_url && quote.source_url.length > 0 ? " (%s)" % [get_source_link(quote.source_url)] : ""]
        xml.pubDate quote.created_at.rfc822
        xml.guid [request.host_with_port+request.relative_url_root, quote.user.login, quote.author, quote.id.to_s].join(":"), "isPermaLink" => "false"
        xml.author "#{quote.author}"
        xml.link quote_url(quote)
      end
    end    
  end
end