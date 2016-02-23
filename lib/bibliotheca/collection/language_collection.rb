module Bibliotheca::Collection::Languages
  class << self
    def all
      Bibliotheca::Collection::LanguageArray.new Bibliotheca::Language::LANGUAGES
    end
  end
end
