module Bibliotheca
  class User < Mumukit::Service::Document
    include Mumukit::Platform::User::Helpers

    def permissions
      Mumukit::Auth::Permissions.parse self[:permissions]
    end
  end
end
