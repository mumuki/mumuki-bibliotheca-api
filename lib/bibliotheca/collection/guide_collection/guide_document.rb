class Bibliotheca::Collection::Guides::GuideDocument
  def initialize(document)
    @document = document
  end

  def method_missing(name, *args, &block)
    wrapped.send name, *args, &block
  end

  def as_json(options={})
    wrapped.as_json(options)
  end

  def raw
    @document
  end

  private

  def wrapped
    @wrapped ||= Bibliotheca::Guide.new(@document)
  end

end