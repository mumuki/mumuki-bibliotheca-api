module Bibliotheca::Event
  extend Mumukit::Nuntius::EventConsumer::HandlerModule

  define_handler :UserChanged do |data|
    user = data[:user]
    Bibliotheca::Collection::Users.upsert_permissions! user[:uid], user[:permissions]
  end
end
