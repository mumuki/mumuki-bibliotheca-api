class UpsertOrganization
  def self.execute!(payload)
    organization = payload['organization']
    return if organization[:name] != 'base'

    Bibliotheca::Collection::Organizations.upsert! organization
  end
end

class OrganizationCreated < UpsertOrganization
end

class OrganizationChanged < UpsertOrganization
end
