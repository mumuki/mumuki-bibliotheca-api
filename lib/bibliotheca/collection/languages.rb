module Bibliotheca::Collection::Languages
  class << self
    def all
      LanguageArray.new Bibliotheca::Language::LANGUAGES
    end
  end
end

require_relative './language_collection/language_array'