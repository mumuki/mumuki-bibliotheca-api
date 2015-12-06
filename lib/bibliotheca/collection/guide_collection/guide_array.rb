class Bibliotheca::Collection::Guides::GuideArray
  def initialize(array)
    @array = array
  end

  def as_json(options={})
    {guides: @array.as_json({only: [:id, :name, :slug, :language, :type]}.merge(options))}
  end
end