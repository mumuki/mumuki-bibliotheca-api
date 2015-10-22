module GitIo::Operation
end

require_relative './operation/with_file_reading'

require_relative './operation/guide_reader'
require_relative './operation/exercise_reader'

require_relative './operation/guide_builder'
require_relative './operation/exercise_builder'

require_relative './operation/operation'

require_relative './operation/export'
require_relative './operation/import'

require_relative './operation/import_log'
