class Presenter
  extend ::EventHandler

  def self.inherited(base)
    base.send :include, Redis::Objects
  end

  def id
    self.class.name
  end
end
