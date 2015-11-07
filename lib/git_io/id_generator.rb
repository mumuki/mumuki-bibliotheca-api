require 'securerandom'

class IdGenerator
  def self.next
    SecureRandom.hex(8)
  end
end