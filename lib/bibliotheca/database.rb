module Bibliotheca::Database
  extend Mumukit::Service::Database

  def self.client
    @client ||= new_database_client config[:database]
  end
end