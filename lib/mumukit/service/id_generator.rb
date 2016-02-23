require 'securerandom'

class Mumukit::Service::IdGenerator
  def self.next
    SecureRandom.hex(8)
  end
end