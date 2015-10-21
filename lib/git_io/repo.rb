class GitIo::Repo
  attr_accessor :name, :organization

  def initialize(name, organization)
    @name = name
    @organization = organization
  end

  def full_name
    "#{organization}/#{name}"
  end
end