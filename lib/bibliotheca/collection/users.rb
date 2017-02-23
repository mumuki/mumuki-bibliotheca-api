module Bibliotheca::Collection
  module Users
    extend Mumukit::Service::Collection

    def self.upsert_permissions!(uid, permissions)
      upsert_attributes!({uid: uid}, {permissions: permissions.as_json})
    end

    def self.find_by_uid!(uid)
      find_by! uid: uid
    end

    def self.for_profile(profile)
      upsert_by! :uid, Bibliotheca::User.new(profile)
      find_by_uid! profile.uid
    end

    def self.import_from_json!(json)
      upsert_permissions! json[:uid], json[:permissions]
    end

    private

    def self.mongo_collection_name
      :users
    end

    def self.mongo_database
      Bibliotheca::Database
    end

    def self.wrap(it)
      Bibliotheca::User.new it
    end
  end
end
