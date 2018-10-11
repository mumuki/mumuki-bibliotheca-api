Mumuki::Bibliotheca::Nuntius.event_consumer.handle do
  # Emitted by:
  #    * new logins in laboratory
  #    * new logins in classroom
  #    * user creation and modification in laboratory
  #    * user creation and modification in classroom
  event :UserChanged do |data|
    Bibliotheca::Collection::Users.import_from_json! data[:user].except(:created_at, :updated_at)
  end

  # Emitted by organization creation and modification in laboratory
  event :OrganizationChanged do |payload|
    Bibliotheca::Collection::Organizations.import_from_json! payload[:organization].except(:created_at, :updated_at)
  end
end
