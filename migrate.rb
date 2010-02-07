require File.dirname(__FILE__) + '/quotes'

def migration(migration_id)
  if Quotes.redis.get("quotes:_migrations:#{migration_id}")
    puts "Ignored #{migration_id}"
    return 
  end
  puts "Running #{migration_id}..."
  yield
  Quotes.redis.set "quotes:_migrations:#{migration_id}", Time.now
end

migration :set_html_text_to_quotes do
  Quotes::Quote.all.each { |params| Quotes::Quote.update(params) }
end