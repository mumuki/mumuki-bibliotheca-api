class Bibliotheca::Collection::GuideArray < Mumukit::Service::JsonArrayWrapper

  def options
    {only: [:id, :name, :slug, :language, :type]}
  end

  def key
    :guides
  end
end