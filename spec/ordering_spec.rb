require 'spec_helper'

include GitIo

def position_after_ordering(ordering, position)
  ordering.position_for(position)
end

describe Ordering do

  it { expect(Ordering.from(nil)).to be NaturalOrdering }
  it { expect(Ordering.from([2, 3, 4])).to be_a FixedOrdering }

  it { expect(position_after_ordering(NaturalOrdering, 4)).to eq 4 }

  describe FixedOrdering do
    let(:ordering) { FixedOrdering.new([4, 20, 3]) }

    it { expect(ordering.position_for(20)).to eq 2 }

    it { expect(position_after_ordering(ordering, 4)).to eq(1) }
    it { expect(position_after_ordering(ordering, 20)).to eq(2) }
    it { expect(position_after_ordering(ordering, 3)).to eq(3) }
  end
end
