class Bibliotheca::Event::UserChanged
  class << self
    def execute!(data)
      user = data[:user]
      Mumukit::Auth::Store.set! user[:uid], user[:permissions]
    end
  end
end
