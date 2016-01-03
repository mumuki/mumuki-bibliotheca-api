module Bibliotheca
  class JsonWrapper
    attr_accessor :raw

    def initialize(json)
      @raw = json.to_h.symbolize_keys
    end

    def as_json(options={})
      json.as_json(options)
    end

    def method_missing(name, *args)
      json[name]
    end

    def transforms(original)
      {}
    end

    def json
      @json ||= defaults.
                merge(@raw).
                merge(transforms(@raw))
    end
  end
end