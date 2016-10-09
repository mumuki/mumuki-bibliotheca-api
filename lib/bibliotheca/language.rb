module Bibliotheca
  class Language < Mumukit::Service::JsonWrapper
    def as_json(options={})
      if options[:full_language]
        super
      else
        name
      end
    end
  end
end
