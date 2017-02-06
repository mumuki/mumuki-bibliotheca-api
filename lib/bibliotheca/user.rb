module Bibliotheca
  class User < Mumukit::Service::Document
    include Mumukit::Login::UserPermissionsHelpers

    def permissions
      Mumukit::Auth::Permissions.parse self[:permissions]
    end
  end
end
