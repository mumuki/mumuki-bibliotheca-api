Dir.glob('lib/tasks/*.rake').each { |r| import r }

require_relative './lib/bibliotheca'

Mongo::Logger.logger = ::Logger.new(File.join 'logs', 'rake.mongo.log')
Mongo::Logger.logger.level = ::Logger::INFO
