module Bibliotheca::Collection
  module Languages
    class << self
      def all
        Bibliotheca::Collection::LanguageArray.new Bibliotheca::Language::LANGUAGES
      end
    end
  end

  class LanguageArray < Mumukit::Service::JsonArrayWrapper
    def options
      {full_language: true}
    end

    def key
      :languages
    end
  end
end
