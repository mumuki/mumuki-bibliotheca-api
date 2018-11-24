Mumukit::Nuntius::EventConsumer.handle do
  # Emitted by:
  #    * new logins in laboratory
  #    * new logins in classroom
  #    * user creation and modification in laboratory
  #    * user creation and modification in classroom
  event :UserChanged do |data|
    User.import_from_resource_h! payload.deep_symbolize_keys[:user]
  end

  # Emitted by organization creation and modification in laboratory
  event :OrganizationChanged do |payload|
    Organization.import_from_resource_h! payload.deep_symbolize_keys[:organization]
  end
end
