module GitIo::Operation
  class ExportLog
    def with_error_logging
      yield
    rescue => e
      messages << e.inspect #TODO add stacktrace
    end
  end
end