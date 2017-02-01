class Bibliotheca::Event::UserChanged
  class << self
    def execute!(data)
      user = data[:user]
      Bibliotheca::Collection::Users.upsert_permissions! user[:uid], user[:permissions]
    end
  end
end
