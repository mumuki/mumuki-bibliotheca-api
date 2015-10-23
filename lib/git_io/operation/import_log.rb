module GitIo::Operation
  class ImportLog < GitIo::Operation::Log
    def no_description(name)
      messages << "Description does not exist for #{name}"
    end

    def no_meta(name)
      messages << "Meta does not exist for #{name}"
    end
  end
end