class QuotePresenter < Presenter

  def self.quotes
    Redis::HashKey.new('quote_presenter:quotes', :marshal => true)
  end

  def self.find(uid)
    quotes[uid]
  end

  def self.find_all(uids)
    return [] unless uids.any?
    quotes.bulk_get(*uids).values
  end

  on :quote_added do |event|
    quotes[event[:uid]] = event.slice(:text, :author, :source, :uid, :nickname).merge(
      :html => RedCloth.new(event[:text]).to_html
    )
  end

  on :quote_amended do |event|
    quotes[event[:uid]] = quotes[event[:uid]].merge(event.slice(:text, :author, :source).merge(
      :html => RedCloth.new(event[:text]).to_html
    ))
  end

end
