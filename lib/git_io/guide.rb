module GitIo
  class Guide
    def initialize(json)
      @json = json
    end

    def beta
      @json[:beta] || false
    end

    def learning
      @json[:learning] || false
    end

    def exercises
      @exercises ||= @json[:exercises].map { |e| OpenStruct.new e }
    end

    def as_json
      @json
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