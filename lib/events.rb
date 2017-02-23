Mumukit::Nuntius::EventConsumer.handle do
  event :UserChanged do |data|
    Bibliotheca::Collection::Users.import_from_json! data[:user]
  end

  [:OrganizationCreated, :OrganizationChanged].each do |it|
    event it do |payload|
      organization = payload[:organization]
      Bibliotheca::Collection::Organizations.upsert! organization if organization[:name] == 'base'
    end
  end
end
