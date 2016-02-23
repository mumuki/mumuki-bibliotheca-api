class Bibliotheca::Collection::BookArray < Mumukit::Service::JsonArrayWrapper

  def options
    {only: [:id, :name, :slug]}
  end

  def key
    :books
  end
end