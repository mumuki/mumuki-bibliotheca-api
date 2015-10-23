class GitIo::Repo
  attr_accessor :name, :organization

  def initialize(name, organization)
    @name = name
    @organization = organization
  end

  def full_name
    "#{organization}/#{name}"
  end

  def self.from_full_name(full_name)
    self.new *full_name.split('/')
  end
end