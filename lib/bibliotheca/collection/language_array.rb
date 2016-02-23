class Bibliotheca::Collection::LanguageArray < Mumukit::Service::JsonArrayWrapper

  def options
    {full_language: true}
  end

  def key
    :languages
  end
end