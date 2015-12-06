class Bibliotheca::Repo
  attr_accessor :organization, :name

  def initialize(organization, name)
    @organization = organization
    @name = name
  end

  def full_name
    "#{organization}/#{name}"
  end

  def self.from_full_name(full_name)
    self.new *full_name.split('/')
  end
end