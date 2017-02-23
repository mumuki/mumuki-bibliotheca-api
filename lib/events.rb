Mumukit::Nuntius::EventConsumer.handle do
  event :UserChanged do |data|
    Bibliotheca::Collection::Users.import_from_json! data[:user]
  end
end
