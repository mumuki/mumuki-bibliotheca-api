class Bibliotheca::Event::UserChanged
  class << self
    def execute!(user)
      user_h = user.with_indifferent_access[:user]
      Mumukit::Auth::Store.set! user_h[:uid], user_h[:permissions]
    end
  end
end
