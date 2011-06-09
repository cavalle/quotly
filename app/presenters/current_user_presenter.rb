class CurrentUserPresenter < Presenter
  def self.users
    Redis::HashKey.new('current_user_presenter:users', :marshal => true)
  end

  def self.find(external_uid)
    users[external_uid]
  end

  on :user_registered do |event|
    users[event[:external_uid]] = event.slice(:nickname)
  end
end
