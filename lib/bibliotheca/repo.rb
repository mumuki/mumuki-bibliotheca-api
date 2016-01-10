class Bibliotheca::Repo
  attr_accessor :organization, :name

  def initialize(organization, name)
    @organization = organization
    @name = name
  end

  def slug
    "#{organization}/#{name}"
  end

  def web_hook_url
    "http://bibliotheca.mumuki.io/guides/import/#{slug}"
  end

  def self.from_full_name(slug)
    validate_slug! slug

    self.new *slug.split('/')
  end

  private

  def self.validate_slug!(slug)
    unless slug =~ /.*\/.*/
      raise Bibliotheca::InvalidSlugFormatError.new('Slug must be in organization/repository format')
    end
  end
end

class Bibliotheca::InvalidSlugFormatError < StandardError
end