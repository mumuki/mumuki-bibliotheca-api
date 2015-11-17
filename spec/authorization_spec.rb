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