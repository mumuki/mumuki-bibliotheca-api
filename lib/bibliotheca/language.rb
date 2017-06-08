module Bibliotheca
  class Language < Mumukit::Service::Document
    def as_json(options={})
      if options[:full_language]
        super
      else
        name
      end
    end

    def run_tests!(request)
      Mumukit::Bridge::Runner.new(test_runner_url).run_tests! request
    end
  end
end
