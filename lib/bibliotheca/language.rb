module Bibliotheca
  class Language < Mumukit::Service::Document

    def as_json(options={})
      if options[:full_language]
        super
      else
        name
      end
    end
  end
end
