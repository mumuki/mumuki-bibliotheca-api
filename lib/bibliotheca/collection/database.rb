module Bibliotheca::Collection::Database
  def self.client
    config = get_config
    @client ||= Mongo::Client.new(
        ["#{config[:host]}:#{config[:port]}"],
        {user: config[:user], password: config[:password], database: config[:database]})
  end

  def self.get_config
    environment ||= ENV['RACK_ENV'] || 'development'
    YAML.load(ERB.new(File.read('config/database.yml')).result).with_indifferent_access[environment]
  end
end