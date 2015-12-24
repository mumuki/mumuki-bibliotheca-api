module Bibliotheca
  module Ordering
    def self.from(order)
      order ? FixedOrdering.new(order) : NaturalOrdering
    end
  end

  class FixedOrdering
    def initialize(order)
      @order = order
    end

    def position_for(id)
      @order.index(id) + 1
    end
  end

  module NaturalOrdering
    def self.position_for(id)
      id
    end
  end
end