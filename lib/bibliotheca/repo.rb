class Bibliotheca::Repo
  attr_accessor :organization, :name

  def initialize(organization, name)
    @organization = organization
    @name = name
  end

  def full_name
    "#{organization}/#{name}"
  end

  def web_hook_url
    "http://bibliotheca.mumuki.io/guides/import/#{full_name}"
  end

  def self.from_full_name(full_name)
    self.new *full_name.split('/')
  end
end
