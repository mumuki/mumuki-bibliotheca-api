module Bibliotheca
  class JsonWrapper
    def initialize(json)
      json = json.to_h.symbolize_keys
      @json = defaults.
          merge(json).
          merge(transforms(json))
    end

    def as_json(options={})
      @json.as_json(options)
    end

    def method_missing(name, *args)
      @json[name]
    end

    def transforms(original)
      {}
    end
  end
end