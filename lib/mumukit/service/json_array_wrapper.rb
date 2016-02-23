module Mumukit::Service
  class JsonArrayWrapper
    attr_accessor :raw

    def initialize(raw)
      @raw = raw
    end

    def as_json(options={})
      {}.tap do |json|
        json[key] = raw.as_json(self.options.merge(options))
      end
    end

    def key
      :array
    end

    def options
      {}
    end
  end
end