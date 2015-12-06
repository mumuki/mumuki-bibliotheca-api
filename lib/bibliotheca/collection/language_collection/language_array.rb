class Bibliotheca::Collection::Languages::LanguageArray
  def initialize(array)
    @array = array
  end

  def as_json(options={})
    {languages: @array.as_json({full_language: true}.merge(options))}
  end
end