module Bibliotheca::Database
  extend Mumukit::Service::Database

  def self.client
    @client ||= new_database_client config[:database]
  end

  def self.config
    environment = ENV['RACK_ENV'] || 'development'
    @config ||= read_interpolated_yaml("#{Rails.root}/config/database.yml").with_indifferent_access[environment]['mongo']
  end
end
