require 'securerandom'

class Bibliotheca::IdGenerator
  def self.next
    SecureRandom.hex(8)
  end
end