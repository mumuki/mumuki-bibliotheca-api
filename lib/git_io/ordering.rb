module GitIo
  module Ordering
    def self.from(order)
      order ? FixedOrdering.new(order) : NaturalOrdering
    end
  end

  class FixedOrdering
    def initialize(order)
      @order = order
    end

    def position_for(original_id)
      @order.index(original_id) + 1
    end
  end

  module NaturalOrdering
    def self.position_for(original_id)
      original_id
    end
  end
end