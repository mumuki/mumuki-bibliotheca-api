module Janitor
  class Grant
    def initialize(pattern)
      @pattern = pattern
    end

    def allows?(slug)
      case @pattern
        when '*' then
          true
        when /(.*)\/\*/
          !!(Regexp.new("^#{$1}/.*") =~ slug)
        else
          slug == @pattern
      end
    end

    def to_s
      @pattern
    end

    def as_json(options={})
      to_s
    end
  end
end

require 'jwt'
require 'active_support/all'


module Janitor
  class Token
    SECRET = 'MY-SECRET'
    ALGORITHM = 'HS512'

    attr_reader :grant, :iat, :uuid

    def initialize(grant, uuid, iat)
      @grant = grant
      @uuid = uuid
      @iat = iat
    end

    def as_jwt
      as_json
    end

    def encode
      JWT.encode as_jwt, SECRET, ALGORITHM
    end

    def self.decode(encoded)
      jwt = JWT.decode(encoded, SECRET, true, {:algorithm => ALGORITHM})[0]
      Token.build jwt['grant'], jwt['uuid'], jwt['iat']
    end

    def self.build(slug, uuid = SecureRandom.hex(4), iat = DateTime.current.utc.to_i)
      new Grant.new(slug), uuid, iat
    end
  end
end


describe Janitor::Token do
  let(:slug) { 'mumuki/mumuki-pdep-fundamentos-ruby-guia-34-el-method-missing' }
  let(:token) { Janitor::Token.build(slug) }


  describe '#encode' do
    it { expect(token.as_jwt['grant']).to eq slug }
    it { expect(token.encode).to_not eq Janitor::Token.build(slug).encode }
    it { expect(token.encode).to eq token.encode }
    it { expect(token.encode.size).to be < 384 }

  end

  describe '#decode' do
    let(:decoded) { Janitor::Token.decode(token.encode) }
    it { expect(decoded.grant.to_s).to eq slug }
    it { expect(decoded.uuid).to eq token.uuid }
    it { expect(decoded.iat).to eq token.iat }

    it { expect { Janitor::Token.decode('123445') }.to raise_error }
    it { expect { Janitor::Token.decode(nil) }.to raise_error }
  end

end

describe Janitor::Grant do
  describe 'grant all' do
    let(:grant) { Janitor::Grant.new('*') }

    it { expect(grant.allows? 'foo/bar').to be true }
  end

  describe 'grant org' do
    let(:grant) { Janitor::Grant.new('foo/*') }

    it { expect(grant.allows? 'foo/bag').to be true }
    it { expect(grant.allows? 'foo/baz').to be true }
    it { expect(grant.allows? 'fooz/baz').to be false }
    it { expect(grant.allows? 'xfoo/baz').to be false }
  end

  describe 'grant one' do
    let(:grant) { Janitor::Grant.new('foo/bar') }

    it { expect(grant.allows? 'foo/bag').to be false }
    it { expect(grant.allows? 'foo/bar').to be true }
    it { expect(grant.allows? 'fooz/baz').to be false }
  end
end