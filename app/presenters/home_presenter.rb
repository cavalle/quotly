class HomePresenter < Presenter

  def self.quote_uids
    Redis::List.new("home_presenter:quotes", :marshal => true)
  end

  def self.find
    { :quotes => QuotePresenter.find_all(quote_uids[-20..-1].reverse) }
  end

  on :quote_added do |event|
    quote_uids << event[:uid]
  end

end
