module GitIo
  class Exercise

  end

  class Guide
    def initialize(json)
      @json = {beta: false,
               learning: false,
               original_id_format: '%05d'}.merge(json)
    end

    def exercises
      @exercises ||= @json[:exercises].map { |e| OpenStruct.new e }
    end

    def as_json(options)
      @json.as_json(options)
    end

    def language
      @language ||= Language.find_by_name(@json[:language])
    end

    def method_missing(name, *args)
      @json[name]
    end

    def format_original_id(exercise)
      self.original_id_format % exercise[:original_id]
    end
  end
end