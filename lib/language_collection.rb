module LanguageCollection
  class << self
    def all
      GuideArray.new GitIo::Language::LANGUAGES
    end
  end
end


class GuideArray
  def initialize(array)
    @array = array
  end

  def as_json(options={})
    {languages: @array.as_json({full_language: true}.merge(options))}
  end
end