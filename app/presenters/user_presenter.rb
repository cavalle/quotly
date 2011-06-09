class UserPresenter < Presenter

  def self.quotes(nickname)
    Redis::List.new("user_presenter:quotes:#{nickname}", :marshal => true)
  end

  def self.users
    Redis::Set.new("user_presenter:nicknames")
  end

  def self.find(nickname)
    Event.find(99999) unless users.include?(nickname)
    { :nickname => nickname, :quotes => QuotePresenter.find_all(quotes(nickname)) }
  end

  on :quote_added do |event|
    quotes(event[:nickname]) << event[:uid]
  end

  on :user_registered do |event|
    users << event[:nickname]
  end

end
