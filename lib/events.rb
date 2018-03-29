Mumukit::Nuntius::EventConsumer.handle do
  event :UserChanged do |data|
    Bibliotheca::Collection::Users.import_from_json! data[:user].except(:created_at, :updated_at)
  end

  event :OrganizationChanged do |payload|
    Bibliotheca::Collection::Organizations.import_from_json! payload[:organization].except(:created_at, :updated_at)
  end
end
